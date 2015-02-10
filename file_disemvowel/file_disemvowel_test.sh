#!/bin/bash

outputFile=`mktemp /tmp/disemvowel_output.XXXXX`

testDisemvowelStandardInput()
{
    rm $outputFile
    ./file_disemvowel < small_input > $outputFile
    diff small_output $outputFile
    assertTrue "Incorrect output file, try 'diff small_output $outputFile' for more info" "[[ $? == 0 ]]"
}

testDisemvowelInfileStdout()
{
    rm $outputFile
    echo ""
    echo "If this test hangs, you're probably trying to read from standard"
    echo "input instead of from the file provided on the command line."
    echo "Hit ^D to terminate the program and check that your program"
    echo "handles command line arguments properly."
    echo ""
    ./file_disemvowel small_input > $outputFile
    diff small_output $outputFile
    assertTrue "Incorrect output file, try 'diff small_output $outputFile' for more info" "[[ $? == 0 ]]"
}

testDisemvowelInfileOutFile()
{
    rm $outputFile
    echo ""
    echo "If this test hangs, you're probably trying to read from standard"
    echo "input instead of from the file provided on the command line."
    echo "Hit ^D to terminate the program and check that your program"
    echo "handles command line arguments properly."
    echo ""
    echo "If this fails and it looks like you're printing out the result"
    echo "of disemvoweling, then you may be writing to standard output"
    echo "instead of to the file specified as a command line argument"
    echo ""
    ./file_disemvowel small_input $outputFile
    diff small_output $outputFile
    assertTrue "Incorrect output file, try 'diff small_output $outputFile' for more info" "[[ $? == 0 ]]"
}

# load shunit2 and run the tests.
. ../lib/shunit2
