# Project 3: Course Paper

Research and write a paper discussing a current computer architectural topic/issue. Specific requirements:

1. Originality:This topic and paper must be researched and written this semester for this class(i.e. a paper from a previous class is not allowed to be used).
2. Sources: You must have at least three sources. Wikipedia may be used, but counts for at most ONE source.
3. Bibliography: Append a list of resources/references used to the end of your paper. You can pick the format. See note below.
4. Length: 3 to 5 pages.
5. Content: Your paper should have some analysis, not just a rehashing of the sources that you found. For instance, if discussing a problem, how serious a problem is it and are the solutions you discovered likely to really work?
6. No name! Please do not place your name on the paper itself -- only on the coversheet that will be provided and stapled to your paper.
7. Quotations: Use your own words. Use quotations where necessary, but this should be infrequent and brief.
8. Format: Your paper must be typed.

## Important note on sources and the bibliography

* You can use web pages, but the best sources are papers/articles that have been
  PUBLISHED in some way, with a particular date.
  
* Therefore, when you find a source online, search around to find out if it was
  actually published somewhere. If so, cite it based on that (much better than
  just giving the URL of where you found it!)
  
* EXAMPLE: you find this source:
http://web.eecs.umich.edu/~taustin/papers/MICRO32-diva.pdf. Looking at the PDF
file reveals it was published in a conference, so it should be cited with
something like this: Todd M. Austin. DIVA: A Reliable Substrate for Deep
Submicron Microarchitecture Design. Proceedings of the 32nd International
Symposium on Microarchitecture, November 1999.

* Not every PDF file will say where it was published. If it doesn't, also Google
  for the title of the paper/article (put quotes around the name) -- if it was
  published somewhere, you will find a page listing the table of contents for
  that publication, or often a page maintained by the author that lists the
  details of his/her publications.

## Specific Deliverable


1. Paper description: Submit your description to your instructor (see calendar for deadline) via plain text e-mail (do NOT send a Microsoft Word document etc.). Include the following:
   * A topic. See topic suggestions below. You may also propose your own. One
     restriction: you may not use the Pentium division bug as a topic! (later
     you will get a sample paper).
   * A summary. In a few sentences, describe the issue, your sources, and, if
     applicable, the particular solution(s) that you will consider for this
     problem.
   * **The subject of your email should be formatted like below**, where `<name>` is replace with your first and last name, and `<topic>` is replaced with your topic name. You should NOT include the `<` and `>` in your subject like (that is, the entirity of `<name>` and `<topic>` should be replaced!).
```   
   IC220 - Project 3 Topic -- <name> -- <topic>
```
    
2. TWO copies of Paper v1.0. See calendar for due date. You will submit a
   complete, well-written draft of your paper (see calendar for deadline). Very
   soon thereafter, we will devote one day of class to peer review: everyone
   will read and give constructive feedback on two papers. You will receive this
   feedback, and will use it to revise the paper.
   
3. Final paper submission. See calendar for due date. Be sure that you have
   revised the paper based on the comments you received. Turn in:
   * Paper coversheet (to be provided)
   * Your final, polished paper. Staple to coversheet but do NOT put your name
     on the paper itself. Be sure to follow the bibliography note above.
   * The two copies of Paper v1.0, with comment sheets. Do not staple these to
     the full paper (you will turn in via a separate pile).

## Grading

* 5%: Paper description, on-time. A topic alone is not a description.
* 15%: Paper v1.0 submitted on-time and complete.
* 5%: Providing good feedback to other students' papers.
* 75%: Final paper.

## Suggested Topics

NOTE: where links are provided, they often refer to original articles (from
several years ago) that "set the tone" -- use such articles for your initial
understanding, and then also seek out more recent articles to understand the
state-of-the-art.


* GPUs

* Transactional memory

* "Free instruction sets", such as "RISC-V".  See http://riscv.org/publications.html, and especially "Instruction Sets Should Be Free: The Case For RISC-V", available at http://www.eecs.berkeley.edu/Pubs/TechRpts/2014/EECS-2014-146.pdf 

* Very Long Instruction Word (VLIW) machines.  Why do this -- what are the costs and benefits? 

* Costs and benefits from going to a 64-bit architecture.

* Wire delay -- what is it and why are chip designers so scared about it?

* What is a dataflow machine?  Why didn't the idea take over the world?

* Multicore chips

* Writing software for multicore/multiprocessor systems.  Apple's Xcode has some tools for this that you might consider.
Also consider MPI, OpenMP, or Cilk.

* -Also related to writing "parallel code", consider the "Ninja" performance gap:  http://dl.acm.org/citation.cfm?id=2337210&bnc=1

* -Quantum computation

* Simultaneous multithreading:
http://www.cs.washington.edu/research/smt/index.html
(renamed Hyperthreading by Intel)
http://www.intel.com/technology/platform-technology/hyper-threading/index.htm
http://software.intel.com/en-us/articles/intel-hyper-threading-technology-your-questions-answered/

* Fault tolerant computing
(hardware failures or design flaws)
For instance, see DIVA:
http://www.eecs.umich.edu/~taustin/papers/MICRO32-diva.pdf

* Reconfigurable computing.  You could start here:
http://portal.acm.org/citation.cfm?id=1749604
or this older survey
http://portal.acm.org/citation.cfm?id=508353

* Concurrency in hardware and software
One possible place to start:
http://www.gotw.ca/publications/concurrency-ddj.htm

* Why is branch prediction so important?  Investigate and describe
some of the most successful techniques that have been recently 
proposed or used.

* Why is power consumption an increasingly important factor for
processors?  Research and describe some techniques for reducing power consumption.

* Optical based computers or interconnect.

* Issues with scaling down transistor size.

* Formal methods to verify hardware (e.g. model checking, equivalence checking).  
http://www.cerc.utexas.edu/~jay/fv_surveys/

* Virtual machines, VMWare.  How do they work?  Why would you want to use them? 

* More on virtual machines: you could also examine JVMs (Java Virtual Machine), from a hardware point of view.   

* Malware plus virtual machines.  For instance, see 
www.eecs.umich.edu/~pmchen/papers/king06.pdf

* Security and information leakage from a processor?  http://www.cs.columbia.edu/~simha/preprint_isca12_svf.pdf

* Errors in main memory.  For instance, http://dl.acm.org/citation.cfm?id=2150989
