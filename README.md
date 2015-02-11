# "Traversing Directories" starter

# Overview

This repository contains the starter code and tests for the "Traversing directories" lab. 
The primary goal of this lab is to gain some experience with (Unix) (file) system calls in 
C, and compare these to using the shell and Ruby.

For this lab, you will need to have (or develop) some familiarity with
several C programming concepts, including:

-   Using command line arguments
-   Using 2-Dimensional arrays
-   Basics of file-system calls, including standard input (`stdin`) and standard output (`stdout`)
-   Using `stat()`
-   Using `struct`

For comparison, we will also see how to use shell commands and Ruby to traverse directories.

To accomplish these goals, you will work on solving two distinct
problems, both of which illustrate how we interact with the file system
from (C) programs. The first is revisiting an old friend (`disemvowel` from the C Lab), but this time
we disemvowel entire files instead of single lines. The second is four
different solutions to the problem of summarizing files; two
solutions will be in C, one in BASH, and one in Ruby.

# Getting started

You should start by having one member of your team fork this repo to get the
starter code for all four projects. Then everyone on the team should make sure
that they can clone that forked repository.

There are two directories in the repository, one for each of the two
major parts of this lab. We would recommend doing them in the order
listed below; there's no overwhelming reason that you need to do them in
any particular order, however, and it would be far better to move on to
the next one rather than get buried in one and not make any progress.

# File disemvowel

This is an extension of the disemvoweling exercise from the initial C Lab. Here
you should write a program that disemvowels an entire file, reading from
standard input or a file specified on the command line, and writing to
standard output or to a file specified on the command line. Your goal is
to write a program `file_disemvowel` that can be called in all of the
following ways:

### Read from standard input, write to standard output

```bash
> ./file_disemvowel
Some text
consisting of 2 lines. \
^D
Sm txt 
cnsstng f 2 lns.
```

Note that we can also use I/O redirection and pipes to modify standard
input and standard output:

```bash
> cat small_input
Vulcan once stood proud here,
until he spewed his parts from his dirty mouth,
shattering his body and the land alike.
-- Thomas McPhee, 20 Jul 2010
> ./file_disemvowel < small_input > /tmp/output
> cat /tmp/output
Vlcn nc std prd hr,
ntl h spwd hs prts frm hs drty mth,
shttrng hs bdy nd th lnd lk.
-- Thms McPh, 20 Jl 2010
```

### Read from a file, write to standard output

Your program should be able to take a single command line argument that
is taken to be the name of the file to be disemvoweled. The output will
then go to standard output.

```bash
> cat small_input
Vulcan once stood proud here,
until he spewed his parts from his dirty mouth,
shattering his body and the land alike.
-- Thomas McPhee, 20 Jul 2010
> ./file_disemvowel small_input
Vlcn nc std prd hr,
ntl h spwd hs prts frm hs drty mth,
shttrng hs bdy nd th lnd lk.
-- Thms McPh, 20 Jl 2010
```

### Read from a file, write to a file

If your program is provided with two command line arguments, it should
interpret the first as the input file and the second as the file where
the output should be written.

```bash
> cat small_input
Vulcan once stood proud here,
until he spewed his parts from his dirty mouth,
shattering his body and the land alike.
-- Thomas McPhee, 20 Jul 2010
> ./file_disemvowel small_input /tmp/output
> cat /tmp/output
Vlcn nc std prd hr,
ntl h spwd hs prts frm hs drty mth,
shttrng hs bdy nd th lnd lk.
-- Thms McPh, 20 Jl 2010
```

### Test scripts and design suggestions

The directory `file_disemvowel` has a test
script and some test data. You want to start by trying to get
those tests to pass at a minimum but, as always, we make no guarantees
that those tests are in any way complete enough to ensure correctness.

The basic structure of our solution is 
```C
#include <stdio.h>

#define BUF_SIZE 1024

bool is_vowel(char c) { 
    /* 
     * Returns true if c is a vowel (upper or lower case), and 
     * false otherwise. 
     */ 
}

int copy_non_vowels(int num_chars, char* in_buf, char* out_buf) {
    /*
     * Copy all the non-vowels from in_buf to out_buf. 
     * num_chars indicates how many characters are in in_buf, 
     * and this should return the number of non-vowels that
     * that were copied over.
     */
}

void disemvowel(FILE* inputFile, FILE* outputFile) { 
    /*
     * Copy all the non-vowels from inputFile to outputFile.
     * Create input and output buffers, and use fread() to repeatedly read
     * in a buffer of data, copy the non-vowels to the output buffer, and
     * use fwrite to write that out. 
     */
}

int main(int argc, char *argv[]) { 
    FILE *inputFile; 
    FILE *outputFile;

    /* Code that processes the command line arguments and sets up inputFile and outputFile */

    disemvowel(inputFile, outputFile);

    return 0; 
}
```

A few comments:

-   We've used `#define` to create a named constant which I used for the
    size of my two buffers in the function `disemvowel()`.
-   Rather than using the very low-level I/O tools `open()`, `read()`,
    and `write()`, I'm using the slightly higher level tools `fopen()`,
    `fread()`, and `fwrite()`, as they're more like what you'd actually
    use in a text-processing program like this. You'll want to look at
    the man pages for `fopen()`, `fread()`, and `fwrite()` for the
    details, and definitely ask questions if you're not sure what's
    going on there.
-   This uses command line arguments in C. You probably want to start by
    just reading standard input and writing to
    standard input, as that allows you to initially ignore the command
    line arguments and focus on the file operations; once you get that
    right, you should pass the first of the three tests. When that's
    done that you can start worrying about the command line arguments.
    There are lots of on-line resources for handling command line
    arguments in C, e.g., in the wikibook [A Little C Primer](http://en.wikibooks.org/wiki/A_Little_C_Primer/C_Command_Line_Arguments).

------------------------------------------------------------------------
------------------------------------------------------------------------

# Summarizing directories

Here's where we'll generate four different solutions to the same
problem, two in C (using different system tools), one in bash, and one
using Ruby. The problem we're solving in each case is to write a program
that takes a single command line argument and looks at *every* file and
directory from there down (in sub-directories, sub-sub-directories,
etc.) and summarizes how many directories it finds and how many regular
files (non-directories) it finds. The output should look like:

    Processed all the files from </home/mcphee/pub/CSci3401/loads_o_files/>.
    There were 1112 directories.
    There were 10002 regular files.

There is a test script in
`summarize_tree/summarize_tree_test.sh` that will
only pass when all four programs exist and work using these names:

-   `summarize_tree`
-   `summarize_tree_ftw`
-   `summarize_tree.sh`
-   `summarize_tree.rb`

The two files `small_dir_sizes` and `large_dir_sizes` in the repo are
necessary for the tests to pass; you shouldn't remove or change them.

------------------------------------------------------------------------

### C using `stat()`

We'll start with a "traditional" C solution using the `stat()` and
`readdir()` library functions. We've given you a substantial stub for
this in `summarize_tree/summarize_tree.c` which
is also included below:

```C
#include <stdio.h>
#include <sys/stat.h> 
#include <stdbool.h> 
#include <stdlib.h>
#include <dirent.h> 
#include <unistd.h>
#include <string.h>

static int num_dirs, num_regular;

bool is_dir(const char* path) { 
    /*
     * Use the stat() function (try "man 2 stat") to determine if the file
     * referenced by path is a directory or not. Call stat, and then use
     * S_ISDIR to see if the file is a directory. Make sure you check the
     * return value from stat in case there is a problem, e.g., maybe the
     * the file doesn't actually exist. 
     */
}

/* 
 * This is necessary this because the multiple recursion means there's no way to 
 * order them so that all the functions are defined before they're called.
 */ 
void process_path(const char**);

void process_directory(const char* path) { 
    /*
     * Update the number of directories seen, use opendir() to open the
     * directory, and then use readdir() to loop through the entries
     * and process them. You have to be careful not to process the
     * "." and ".." directory entries, or you'll end up spinning in
     * (infinite) loops. Also make sure you closedir() when you're done. 
     *
     * You'll also want to use chdir() to move into this new directory,
     * with a matching call to chdir() to move back out of it when you're
     * done. 
     */
}

void process_file(const char* path) { 
    /*
     * Update the number of regular files.
     */
}

void process_path(const char* path) { 
    if (is_dir(path)) {
        process_directory(path); 
    } else { 
        process_file(path); 
    } 
}

int main (int argc, char *argv[]) { 
    // Ensure an argument was provided.
    if (argc = 2) { 
        printf ("Usage: %s <path>\n", argv[0]); 
        printf ("       where <path> is the file or root of the tree you want to summarize.\n"); 
        return 1; 
    }

    num_dirs = 0; 
    num_regular = 0;

    process_path(argv[1]);

    printf("Processed all the files from <%s>.\n", argv[1]);
    printf("There were %d directories.\n", num_dirs); 
    printf("There were %d regular files.\n", num_regular);

    return 0; 
}
```

#### Static variables as "fields"

The `static int` declaration on line 9 gives us two semi-global
variables that are visible to all the functions *in this file*, but
invisible outside of this file. This gives us something sort of like
fields in a class in a language like Java, 
except that you can't make "instances" of this file
so there are never more than these two integer variables. (This means if
you tried to use this approach for something like a stack, then you
couldn't ever have more than one stack.)

#### Calling stat()

In `is_dir()`, you'll want to use the `stat()` system call
(try `man 2 stat`) to get the "status" of the file identified by `path`.
The signature for `stat()` is 
```C
int stat(const char *path, struct stat *buf);
```
This is typical of many library
functions where the "return value" is actually being written into a
pointer argument (`buf` in this case), and what's returned is an error
code. If the error code is 0, then `stat` worked fine, and its results 
are stored in
`buf`; if the error code is non-zero then there was a problem 
(e.g., the file didn't actually exist) and you can't count on `buf`
containing any meaningful information. What you get in `buf` is a whole
bunch of information including the inode number, access and change
times, etc. (see the `man` page for more). What we care about is the
`st_mode` field; to access that field you need to dereference the
pointer (i.e., `*buf`) and then use the dot notation to access the
field: `(*buf).st_mode`. This syntax is sufficiently awkward (the parens
are necessary because dot binds more tightly than star), that the
designers of C provided an alternative syntax for this common case:
`buf->st_mode`. 

This `st_mode` field contains all the file permission information,
which includes whether it's a directory or not. We could try to extract
that information from `st_mode` directly, but they've given us a
`S_ISDIR()` macro that does that work for us. Then the key expression is
something like 
```C
S_ISDIR(buf->st_mode)
```
An important point about `stat()` is that *doesn't* allocate space for
`buf`; you're supposed to have done that before you call `stat()`. You
can do this with `malloc()`, or you can
actually declare a `struct stat` locally (`struct stat buf`), and pass
it's address to `stat()` with `&buf`. If you do that, `buf` isn't a
pointer, so you don't need the arrow notation above and can just use
```C
S_ISDIR(buf.st_mode)
```

#### Reading directories

In `process_directory` you'll need to have a loop that reads
all the entries in the directory named by the given path, making
recursive calls to process those sub-paths. The basic approach is to use
`opendir()` to open the directory, repeatedly call `readdir()` to read
the next entry from the directory, and then call `closedir()` at the
end. There are a few bits you need to be careful of:

-   You need use `chdir()` at the start of `process_directory()` to
    actually move into the directory you're processing. You'll then to
    use `chdir("..")` to move back up to the parent directory at the end
    of `process_directory()`.
-   You need to check whether `readdir()` gave you either "." or ".." as
    the `d_name`. It will eventually do that since every directory
    contains both those entires. You *don't* want to make recursive
    calls on those, because you'll end up in an infinite loop.

#### Checking for errors

Since C tends to just crash horribly when something goes wrong, you want
to get in the habit of checking for errors so you can try to give your
user some useful feedback. I've provided an example in `main()` where I
check that the program is called with the right number of command line
arguments. You also want to check the result code returned by `stat()`
in `is_dir()`. You should also probably check for errors from things
like `opendir()`, `readdir()`, `closedir()`, and `chdir()`, although
errors there are less likely.

------------------------------------------------------------------------

### C using `ftw()`

Having gotten the version with `stat()` to work, we're now going to do
this again, using a nice library tool called `ftw()` (for "file tree
walk" - really). Here you just need to call `ftw()` (which you can do straight
from `main()` after checking the command line arguments), and it does
all the recursive traversal of the file system for you. What you need to
do is define a function 
```C
static int callback(const char *fpath, const struct stat *sb, int typeflag)
```
and pass it in as the second
argument of `ftw()`, something like this: 
```C
static int callback(const char *fpath, const struct stat *sb, int typeflag) { 
    // Define stuff here 
}

int main(int argc, char** argv) { 
    // Check arguments and set things up

    ftw(argv[1], callback, 16);

    // Print out the results 
}
```

`ftw()` will call your `callback()` function once for every file it
finds, giving you the opportunity to do whatever you wish with that
file. In our case we just determine whether it's a directory or not (the
`typeflag` field is very useful here) and update the appropriate
counter. In more general applications, however, you could check for file
types (image files, for example), copy things, compute their sizes, or
whatever.

------------------------------------------------------------------------

### The shell using find

An alternative to writing this in C is to use shell commands. 
Here we'd recommend using `find` to do the traversal for you (its
`-type` flag is probably useful), and let `wc` do the counting.

------------------------------------------------------------------------

### Ruby

Lastly, we'll solve this problem a fourth time, using Ruby.
Conveniently, Ruby has a `Find` library that gives you file directory
traversal (similar to the command line `find`) and a `FileTest` class
with static methods like `directory?` that tell you if a file is a
directory or not.

The following little script, for example, will print out all the
executable files in or below a specified directory:
```ruby
#!/usr/bin/ruby

require 'find'

Find.find(ARGV[0]) do |path|
  if FileTest.executable?(path)
    puts path
  end
end
```

---

People who contributed to this lab write-up before it was moved to Github include Nic McPhee, Vincent Borchardt, and John McCall.
