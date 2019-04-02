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

Cache's add efficient by taking advantage of *locality*. This refers to the fact
that data access are not truly random, but are dependent events. There are two
major types of locality:

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

We will think of a cache much like we think of addressable main memory. It is an
array of data elements. We refer to each spot in the array as a *cache line*. A
line of cache should store much more than single byte of information, as we like
to think of each addressable unit of main memory. 

Instead, the width of the cache line is what provides spatial locality. When
data at an address from main memory is needed, instead of loading just that
byte, the memory unit will load an entire line of memory, say 64 or 1024 bytes,
of which will include the address of the byte we need. As the next byte needed
is likely nearby, due to spatial locality, this provides a needed boost on the
next access.

Temporal locality is gained simply by the fact that once in the cache, the next
access to the same data is also in the cache. This avoids the extra costs of
having to go back out to main memory for successive accesses. But, at some point
the cache will fill up, and cache lines will need to be ejected. Again,
temporality plays a critical role in this, where we want to try and keep the
most recently accessed items in the cache rather and instead evict least
recently used ones.

With the goals in mind, let's turn our attention to the practical aspects of
building and designing a cache.


## Indexes, Tags, Addresses, and Validity

We will organize our cache, as described before, into lines. Each line, is
referenced by its start address in memory. However, the cache itself is much
smaller than main memory and can only store a fixed number of lines. We refer to
each line in the cache occurring at an *index*. We will map cache lines to an
*index* based on its address.

The most natural way to do this mapping is to take the address and calculate the
index by using a modulo. For example, with 10 lines of cache, an address of 38
would map to index 8, and an address of 26 would map to index 6, and so on. 

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

* *index*:  referring to the line of the cache array calculated using the modulo, or the lower bits of the address
* *tag*: the upper bits of the address used to identify the memory properly matches the address at an index
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
9. 63  `00111111
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
the number of lines of cache.

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
1  (01) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
2  (10) | 0 |       |                     |
        | 0 |       |                     |
        |---|-------|---------------------|
3  (11) | 1 |111101 | 247                 |
        | 1 |001111 | 63                  |
        '---'-------'---------------------'
        
Misses: 5
Hits: 6
```

That was a fortunate choice because the next value we read is 247, which is a
hit. The final total is 5 misses and 7 hits! 


The associativity, while increasing the hit rate, but there is dimension
returns. Increasing the associativity too far means more scanning, and sometimes
increased storage costs for tags and other values, such as tracking the
LRU. Finding a right balance is important.

### Evictions and Multi-Level Caches


L1, L2, etc. 

## Misses 

## Writes 

Write Through

Write Back (dirty bits!)


## Performance Evaluation

## Virtual Memory





