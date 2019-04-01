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
cache. This is the simplest setup.




### Associative Caches

Fully associative vs. set associative 

LRU: least recently used 
* one bit counter, two-associative

### Multi-Level Caches

L1, L2, etc. 

## Misses 

## Writes 

Write Through

Write Back (dirty bits!)


## Performance Evaluation

## Virtual Memory





