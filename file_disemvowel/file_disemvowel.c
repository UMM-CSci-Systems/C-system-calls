#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define BUF_SIZE 1024

bool is_vowel(char c) { 
    /* 
     * Returns true if c is a vowel (upper or lower case), and 
     * false otherwise. 
     */
  return
    c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u' ||
    c == 'A' || c == 'E' || c == 'I' || c == 'O' || c == 'U';
}

int copy_non_vowels(int num_chars, char* in_buf, char* out_buf) {
    /*
     * Copy all the non-vowels from in_buf to out_buf. 
     * num_chars indicates how many characters are in in_buf, 
     * and this should return the number of non-vowels that
     * that were copied over.
     */
  int in_pos = 0;
  int out_pos = 0;
  
  while (in_pos < num_chars) {
    if (!is_vowel(in_buf[in_pos])) {
      out_buf[out_pos] = in_buf[in_pos];
      ++out_pos;
    }
    ++in_pos;
  }
  return out_pos;
}

void disemvowel(FILE* inputFile, FILE* outputFile) { 
    /*
     * Copy all the non-vowels from inputFile to outputFile.
     * Create input and output buffers, and use fread() to repeatedly read
     * in a buffer of data, copy the non-vowels to the output buffer, and
     * use fwrite to write that out. 
     */
  char* in_buf = calloc(BUF_SIZE, sizeof(char));
  char* out_buf = calloc(BUF_SIZE, sizeof(char));
  int num_read, num_copied;
  
  while ((num_read = fread(in_buf, sizeof(char), BUF_SIZE, inputFile)) > 0) {
    num_copied = copy_non_vowels(num_read, in_buf, out_buf);
    fwrite(out_buf, sizeof(char), num_copied, outputFile);
  }
}

int main(int argc, char *argv[]) { 
    FILE *inputFile; 
    FILE *outputFile;

    /* 
     * Code that processes the command line arguments and sets 
     * up inputFile and outputFile 
     */
    
    if (argc == 1) {
      inputFile = stdin;
      outputFile = stdout;
    } else if (argc == 2) {
      inputFile = fopen(argv[1], "r");
      outputFile = stdout;
    } else if (argc == 3) {
      inputFile = fopen(argv[1], "r");
      outputFile = fopen(argv[2], "w");
    } else {
      printf("Illegal number of arguments; needs to be 0, 1, or 2.");
      exit(1);
    }

    disemvowel(inputFile, outputFile);
    
    fclose(inputFile);
    fclose(outputFile);

    return 0; 
}