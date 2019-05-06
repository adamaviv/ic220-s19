# Exploiting the Memory Hierarchy

Memory access, particularly access that require reading/writing to disk, are the
most time consuming part of executing programs. That is because it requires
operations that occur far from the chip itself. Fortunately, there are a number
of ways to exploit the memory hierarchy to improve performance.

## Why is memory slow?

When considering memory or storage for our processors, the first level of data
storage is the registers. Registers are not only storage information, but also
state information for the current execution. Access to the registers is designed
to be fast and cheap as nearly every instruction accesses the memory in some
way.

Beyond register operations, we have memory access that go out to main memory to
load data into the registers. These are our store word (`sw`) and load word
(`lw`) operators. Recall that these operations take an offset and a base
address. The access address is calculated for the operation (read/write). That
is an address in main memory.

However, main memory, even though this may implemented with very fast
operations, like DRAM or SRAM chips, is still significantly slower than access
data that is on the chip, say in a register. The reason is both physics (it's
far away!) and also main memory must be general and handle a lot of different
operations.

Worse! If the data being accessed hasn't yet been loaded into main memory, say
for example, the program is reading from a file on disc, the operation is even
slower. The further away from the CPU a memory operating gets, the slower the
operation.

## Caching and Locality

A common and very effective technique to improve memory access performance is to
use a *cache*. A cache is a storage unit that sits very close to the CPU that
can be used for reads and writes without having to always go out to main memory,
or worse to disk.

Cache's add efficiency by taking advantage of *locality*. This refers to the
fact that data access are not truly random, but are dependent events. There are
two major types of locality:

* Spatial Locality: This refers to the fact that data access are spatially
  related within the address space. When one accesses an item at address `a`,
  the next item to be accessed will likely be at address `a+1`. The reason for
  this is obvious once you consider how array access and loops function; so much
  of the programs we write iterate over concentric data. 
  
* Temporal Locality: This refers to the fact that data that was recently
  accessed is more likely to be accessed again than data accessed much longer
  ago, or never. Again, the reason for this becomes apparent when thinking of
  the programs we write, where most operations occur on a small set of
  memory/data before moving onto to the next set of memory locations.
  
Leveraging these two localities, a cache should store the most recently accessed
data items and be proactive about loading spatially connect data items. That's
exactly what it does, but the routines for managing the cache and achieving this
goal is not always immediately.

## Indexes, Tags, Addresses, and Validity

Recall that memory is referenced by addresses, often 32-bits in size, and each
address references a single byte. A cache then is much like an indexed array,
where each line (or cache line) stores the address information and the data
byte. If we access the same data twice (temporal locality), it will already be
at that index location in the array. 

The size of the array of cache lines is typically referred to as the variable
*N*, or the number of lines of cache. But what exactly does a line of cache need
to store? Or moreover, how do we do the mapping of addresses to lines of cache?

The most natural way to do this mapping is to take the address and calculate the
index into the array using a modulo. For example, with 10 lines of cache, an
address of 38 would map to index 8, and an address of 26 would map to index 6,
and so on.

As addresses in our system are 32-bits in size, and we like to think in bits and
powers of 2, instead we should also consider the number of lines of cache as a
modulo of a power of 2. In this case, we can quickly calculate the index based
on the least significant bits of the address.

For example, consider a smaller 8-bit address space with a 16 lines of
cache. Then each line of cache can be indexed with 4-bits. The lower,
least-significant 4-bits of the 8-bit address are sufficient for calculating the
index and are exactly equal to the modulo of 16 of an 8-bit number. To see this,
take the number 133, which is 1000 0101 in binary. The lower 4-bits are 0101, or
5=133%16.


Once the address is matched to an index, via the modulo, we still need a way to
determine if that line of cache is the data we are interested in. For that, we
need to the remaining bits of the address which were lost in the modulo. Those
remaining bits are also stored, and called the *tag*. So to check if a data
element is in the cache, we take the address, match it to a line by finding the
index using the modulo, and then checking the tag.

This is still not enough, though, because it may be the case that the line of
cache is stale or invalid for a number of reason. This can occur at startup, for
example, where all the cache values may be associated with another program. To
address this issue, there is still one more bit information needed, a *validity
bit*.

The final arrangement of a cache is

* *index*: referring to the line of the cache array calculated using the modulo,
  or the lower bits of the address
* *tag*: the upper bits of the address used to identify the memory properly
  matches the address at an index
* *valid bit*: used to check if the data at that index in the cache is valid

## Direct Mapping Cache

A direct mapping cache maps each data being cached to a single line of
cache. This is the simplest setup. To see how it works, let's assume we have
8-bit addresses and 8 lines of cache. 


The layout looks something like this intimately:


```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 0 |       |                     |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 0 |       |                     |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 0 |       |                     |
         '---'-------'---------------------'
```

Note that initially all valid bits are 0, since we are just starting up. Let's
say we complete the following operations. For now, let's assume all the
operations are reads, so we will ignore the data, and instead use that to note
the full address (in base 10)

1. 247 `11110111` 
2. 52  `00110100` 
3. 55  `00110111` 
4. 55  `00110111` 
5. 52  `00110100`
6. 247 `11110111`
7. 29  `00011101`
8. 52  `00110100`
9. 63  `00111111`
10. 55  `00110111` 



At the first two insertions, we have the follow table. 


```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 0 |       |                     |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 0 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 0 |11110  | 247                 |
         '---'-------'---------------------'
         
Misses: 2         
```

These operations are misses because of the current data there is invalid.  The
next read, 55, has an index of `111`. When we look at that line of cache, we see
that the tag doesn't match, and thus it is also a miss. When we load the new
data, we replace that line of cache 247, with 55.


```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 0 |       |                     |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 1 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 1 |00110  | 55                  |
         '---'-------'---------------------'
         
Misses: 3 
```

After a second read to 55, we have our first hit. This takes advantage of the
temporal locality. Same is true for reading 52. But when we read 247 again, we
collide again at index 7, causing a miss and eviction.



```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 0 |       |                     |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 1 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 1 |11110  | 247                 |
         '---'-------'---------------------'
         
Misses: 4
Hits: 2
```

The next operation 29 is also a miss, but the following 52 is another hit.

```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 1 |00011  | 29                  |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 1 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 1 |11110  | 247                 |
         '---'-------'---------------------'
         
Misses: 5
Hits: 3
```
63 is another miss and ejection. 


```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 1 |00011  | 29                  |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 1 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 1 |00111  | 63                  |
         '---'-------'---------------------'
         
Misses: 6
Hits: 3
```



Then 247 misses and ejects 63. Leaving us with the following table.



```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
1  (001) | 1 |00011  | 29                  |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 1 |00110  | 52                  |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 1 |11110  | 247                 |
         '---'-------'---------------------'
         
Misses: 7
Hits: 3
```


In total, we had 7 misses, which is tough, but also 3 hits. Those 3 hits saved a
lot of time on performance. But we can do better.

### Associative Caches

Thinking of the misses from the sequence above, how can we improve it? What if
instead of one tag per line, what if we had one index per two tags. This is
called an *associative cache* because cache lines can occur in multiple
indexes. There is an increased cost to this design because multiple lines must
be searched, but the extra cost is small relative to going to memory.

You may ask then, why not just make the cache fully associative where every
cache line can occur at any index? That would mean for every read operation the
entire cache must be search. That is quite expensive, and so to reduce that
load, we only associate related indexes.

How would we organize the cache? We could do the following by doubling the size
of the cache, where each index just references two lines.


```
 index   valid   tag        data 
         .---.-------.---------------------.
0  (000) | 0 |       |                     |
0  (000) | 0 |       |                     |
1  (001) | 0 |       |                     |
1  (001) | 0 |       |                     |
2  (010) | 0 |       |                     |
2  (010) | 0 |       |                     |
3  (011) | 0 |       |                     |
3  (011) | 0 |       |                     |
4  (100) | 0 |       |                     |
4  (100) | 0 |       |                     |
5  (101) | 0 |       |                     |
5  (101) | 0 |       |                     |
6  (110) | 0 |       |                     |
6  (110) | 0 |       |                     |
7  (111) | 0 |       |                     |
7  (111) | 0 |       |                     |
         '---'-------'---------------------'
```

But, what if we have a fixed size cache? Instead, we can reduce the index values
(the modulo) to produce the following association.


```
index   valid   tag        data 
        .---.-------.---------------------.
0  (00) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
1  (01) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
2  (10) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
3  (11) | 0 |       |                     |
        | 0 |       |                     |
        '---'-------'---------------------'
```

This requires increasing the tag size by 1 bit, but that is less than doubling
the number of lines of cache. The result is that we have a cache with the same
number of lines (N) but with an associativity of 2, so the modulo is N/2 for
mapping addresses to indexes.

```
index = address % (N/associtivity)
```

Let's again work through the example from before performing reads on the
following items.

1. 247 `11110111` 
2. 52  `00110100` 
3. 55  `00110111` 
4. 55  `00110111` 
5. 52  `00110100`
6. 247 `11110111`
7. 29  `00011101`
8. 52  `00110100`
9. 63  `00111111`
10. 247 `11110111`



This time we start off the same way, but when we get to reading 55 (line 3)

```
index   valid   tag        data 
        .---.-------.---------------------.
0  (00) | 1 |001101 |52                   |
        | 0 |       |                     |
        |---|-------|---------------------|
1  (01) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
2  (10) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
3  (11) | 1 |111101 | 247                 |
        | 1 |001101 | 55                  |
        '---'-------'---------------------'
        
Misses: 3
Hits: 3
```

The cache looks different. We keep 247 in the cache AND 247 because the index
can handle two slots. This means the next 55, 52, and 247 all hit! Following, 29
misses, but 52 hits. 


```
index   valid   tag        data 
        .---.-------.---------------------.
0  (00) | 1 |001101 | 52                  |
        | 0 |       |                     |
        |---|-------|---------------------|
1  (01) | 0 |0001110| 29                  |
        | 0 |       |                     |
        |---|-------|---------------------|
2  (10) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
3  (11) | 1 |111101 | 247                 |
        | 1 |001101 | 55                  |
        '---'-------'---------------------'
        
Misses: 4
Hits: 6
```



But 63 misses and collides with index 3. There are already two values in that
slot. Which do we eject? The common choice is to eject the *least recently
used*. Which in this case is 55. Leaving the following table.


```
index   valid   tag        data 
        .---.-------.---------------------.
0  (00) | 1 |001101 |52                   |
        | 0 |       |                     |
        |---|-------|---------------------|
1  (01) | 0 |0001110| 29                  |
        | 0 |       |                     |
        |---|-------|---------------------|
2  (10) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
3  (11) | 1 |111101 | 247                 |
        | 1 |001111 | 63                  |
        '---'-------'---------------------'
        
Misses: 5
Hits: 5
```

That was a fortunate choice because the next value we read is 247, which is a
hit. The final total is 5 misses and 5 hits! 

The associativity, while increasing the hit rate, but there is diminishing
returns. Increasing the associativity too far means more scanning, and sometimes
increased storage costs for tags and other values, such as tracking the
LRU. Finding a right balance is important.

### Increasing the block size

So far we've been leveraging temporal locality, but let's also consider taking
advantage of spatial locality. This means increasing the *block size*. So far,
we've had a block size of 1. That means for every access, we load a single block
if there is a miss. What if we increased the block size to 2. That means for
every miss, we not only load just that block, but also its adjacent block. 

For this, let's consider a block size of 4, which means that every load of new
data into the cache, always loads 4 bytes at a time. Which four bytes though? We
could just take the *next* four addresses, but that may not align nicely, so
instead, we first align, and then take the next four addresses from there.

So for example, with a block size of 4, and address of `x`, we load the address
`(x-x%4)` as the base aligned address, and then the next three blocks. Like so

```
address x

base adddress = x-x%4

loadded address = (x-x%4), (x-x%4)+1, (x-x%4)+2,(x-x%4)+3
```

But, now we have another problem! Consider that the base address is 4 bytes
aligned, due to the modulo, we can no longer simply apply the module to
determine the tag. **Everything would map to the same spot**. To compensate, we
calculate the index using the following formula, based on the higher order bits.

```
index = (address/blocksize) % (N/associativity)
```

The integer division by the block size ensures that the higher order bits play a
role. But we can still use the powers of two. Consider the caclcuations below
for the index.

To see this in action, again let's consider the following sequence of
accesses. To the right, is the address/block size.

1. 247 `11110111` (247/4 = 61, 1=61%4) 
2. 52  `00110100` (52/4  = 13, 1=13%4)
3. 55  `00110111` (55/4  = 13, 1=13%4)
4. 55  `00110111` (55/4  = 13, 1=13%4)
5. 52  `00110100` (52/4  = 13, 1=13%4)
6. 247 `11110111` (247/4 = 61, 1=61%4)
7. 29  `00011101` (29/4  = 7,  3=7%4)
8. 52  `00110100` (52/4  = 13, 1=13%4)
9. 63  `00111111` (63/4  = 15, 3=15%4
10. 247 `11110111`(247/4  = 13, 1=13%4)


If we look at each of these bit sequences, the index is the assigned based on
the 2nd to last two bits, and the last two bits are considered the offset. We
get a pattern like:

```
  tag - index - offset
```

The tag is the portion of the address we need to identify the real address, the
index is the mapping to the cache, and offset is how far into the bits we need
to go to find the index. You can see this is true based on the calculations
above mapping to the bit patterns below.

1. 247 `11110111` `1111-01-11` (index 1)
2. 52  `00110100` `0011-01-00` (index 1)
3. 55  `00110111` `0011-01-11` (index 1)
4. 55  `00110111` `0011-01-11` (index 1)
5. 52  `00110100` `0011-01-00` (index 1)
6. 247 `11110111` `1111-01-11` (index 1)
7. 29  `00011101` `0001-11-01` (index 3)
8. 52  `00110100` `0011-01-00` (index 1)
9. 63  `00111111` `0011-11-11` (index 3)
10. 247 `11110111` `1111-01-11` (index 1)


Note that by increasing the block size, the tag size decreases as well. 


Why does this works so well? Because we are working with powers of 2. So for
example, we can expand this out for larger address. Suppose we have a 32 bit
address, with 8-byte blocks and a 256 blocks of cache. 8 is a power of 2, 2^3,
so we would need 3 bits of offset. Similarly 256 is a power of 2, 2^8, we would
need 8-bits for index. This leaves us with:

```
32 bit address, 8-byte blocks, 256 blocks

21-bits of tag | 8-bits of index | 3 bits of offset
```

Here are some good formulas to know when working with cache addresses:

```
# of bytes in a block = 2^(byte offset)

# of blocks = ( 2^(index) ) * (associativity)

total cache size = (block size) * (# of blocks)

(note: log_2 means "log base two")

if direct mapped: index = log_2 (# of blocks)

if associative: index = log_2 ( (# of blocks) / (associativity) )

# of offset bits = log_2 (block size)
```

Here are some examples using some of the above formulas:

```
Given: 4-byte blocks.
Goal: calculate the # of offset bits.
Work: # of offset bits = log_2 (block size) = log_2 ( 4 ) = 2
```

```
Given: 128 blocks, direct mapped cache.
Goal: calculate the index.
Work: if direct mapped: index = log_2 (# of blocks) = log_2 ( 128 ) = 7
```

```
Given: 128 blocks, 8-way associativity cache.
Goal: calculate the index.
Work: if associative: index = log_2 ( (# of blocks) / (associativity) ) = log_2 ( 128 / 8 ) = log_2 ( 16 ) = 4
```

#### Simulating

Let's now simulate the series of address accesses from before. To simplify, we
will use the address instead of the tag to identify a cache line, and also use
parens to show the individual data bytes being stored.

For the first two accesses, we get the following layout. Note the base address
for 247 is 244, but we load byte at address 247, (247) when we access address
244 as well due to the increased block size.


```
index    address  data0  data1  data3  data4 
        .-------.------.------.------.-------.
  0     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  1     | 244   |(244) | (245)| (246)| (247) | <-use 244 for base address
        | 52    | (52) |  (53)| (54) | (55)  |
        |-------|------|------|------|-------|
  2     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  3     |       |      |      |      |       |
        |       |      |      |      |       |
        '-------'------'------'------'-------'
        
Misses: 2
Hits: 0
```

From there, the next 4 access are hits! 55 is in the same line as 52, and we
don't have to do any evictions. Until 29, who also maps to index 3=7%4. But then
another hit at 52. 


```
index    address  data0  data1  data3  data4 
        .-------.------.------.------.-------.
  0     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  1     | 244   |(244) | (245)| (246)| (247) | 
        | 52    | (52) |  (53)| (54) | (55)  |
        |-------|------|------|------|-------|
  2     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  3     | 28    | (28) | (29) | (30) | (31)  | <- use 28 for base address
        |       |      |      |      |       |
        '-------'------'------'------'-------'
        
Misses: 3
Hits: 5
```

At 63, we have this mapping to index (63/4)=15%4=3. But then our next access was
247, a hit, leaving us with the following layout.

```
index    address  data0  data1  data3  data4 
        .-------.------.------.------.-------.
  0     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  1     | 244   |(244) | (245)| (246)| (247) | 
        | 52    | (52) |  (53)| (54) | (55)  |
        |-------|------|------|------|-------|
  2     |       |      |      |      |       |
        |       |      |      |      |       |
        |-------|------|------|------|-------|
  3     | 28    | (28) | (29) | (30) | (31)  | 
        | 60    | (60) | (61) | (62) | (63)  | <- use 60 for base address
        '-------'------'------'------'-------'
        
Misses: 4
Hits: 6
```

We took advantage of the spatial locality of 52 and 55 to improve the hit rate, and the associativity to avoid extra evictions.

### Handling Misses

Returning to the performance of our CPU, clearly, a miss in the cache is
problematic. It takes more cycles to retrieve a block from memory, then from the
cache. What does a CPU do in those instances? It needs to stall, simply. The
cost of this miss depends on the particularly CPU. 

Misses also are problematic on evictions. If we evict, that data needs to
potentially be written back to memory. So even on a read miss, there may still
be a double penalty for writing data back to memory. What about writes though?
What if we miss on that? Well, we need to potentially both fetch and evict.


How to improve upon this, we need to think more deeply on how writes are
handled.

## Writes 

So far we've only considered a generic access, namely a read, but what if we
also write? We have two choices for this when considering the cache:

1. Write-Through: Here we write not just in the cache, but all the way back to
   main memory. This could be expensive, at least as expensive as a cache miss. 
   
2. Write-Back: Perform write in cache and wait to write back later on
   eviction. But this makes evictions more expensive, and we need to track
   writes.
   
To track writes, we can add a **dirty bit** to the cache. Like the valid tag,
the dirty bit indicates if the data in this block has been written and would
need to be written back later, on eviction. You always, at some point, need to
pay the price for a write.

## Evictions and Multi-Level Caches

One way to decrease the write penalty and the eviction penalty more generally,
is to create a hierarchy of cache, each a little bigger and a little slower and
a little further away from the CPU. We call this cache layers, so we have the L1
cache, the cache closest to the CPU, out to the Ln cache, the one furthest away,
largest, and slowest. After that is main memory.

The way this works is that when you do accesses, most of what you access most
recently should be in the L1 cache. If you have to do a new access, incurring a
miss, that new data is also placed in the L1 cache assuming that you will access
it again. 

On an eviction, the data is evicted from the higher cache to a lower one. So
from L1 to L2. Sine the lower caches are bigger, the likelihood of that cache
also having to do an eviction is low, and increasing less as you go down the
hierarchy. Eventually, though, the lowest order cache will have to evict as
well, and only then do we pay the biggest penalty of writing to main memory. 

Of course, the multi-level cache doesn't help on initial misses. If you miss and
it is nowhere in the cache, then you always have to go out to main memory. But
it does increase temporal locality. If you miss because it is not in the L1
cache, it may have been recently evicted and will still be in the L2 cache, so
the penalty for that is less than going all the way out to main memory.

## Designing our code for Caches

With some understanding of how cache works, we can now think about how our
programs may or may not be well suited for the cache. For example, consider the
following two code blocks:

```
//option 1
for(j=0;j<20;j++)
  for(i=0;i<200;i++)
    x[i][j] = x[i][j]+1;
    

//option 2
for(i=0;i<200;i++)
  for(j=0;j<20;j++)
    x[i][j] = x[i][j]+1;

```

Which one will be more efficient? Option 2 is a much better design because we
move in sequence along each data element in `x[i]`. While in Option 1, we
scatter our access between each of the `x[i]` arrays. 







