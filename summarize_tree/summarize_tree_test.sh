#!/bin/bash

outputFile=`mktemp /tmp/summarize_tree_output.XXXXX`

testCVersionUsingStatOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree ~mcphee/pub/CSci3401/fewer_files/ > $outputFile
    diff small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingStatOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree ~mcphee/pub/CSci3401/loads_o_files/ > $outputFile
    diff large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingFtwOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree_ftw ~mcphee/pub/CSci3401/fewer_files/ > $outputFile
    diff small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingFtwOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree_ftw ~mcphee/pub/CSci3401/loads_o_files/ > $outputFile
    diff large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testBashVersionOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree.sh ~mcphee/pub/CSci3401/fewer_files/ > $outputFile
    diff small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testBashVersionOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree.sh ~mcphee/pub/CSci3401/loads_o_files/ > $outputFile
    diff large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testRubyVersionOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree.rb ~mcphee/pub/CSci3401/fewer_files/ > $outputFile
    diff small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testRubyVersionOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree.rb ~mcphee/pub/CSci3401/loads_o_files/ > $outputFile
    diff large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

# load shunit2 and run the tests.
. ../lib/shunit2
