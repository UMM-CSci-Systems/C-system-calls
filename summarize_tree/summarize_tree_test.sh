#!/bin/bash

testDataDir=`mktemp -d /tmp/summarize_tree_data.XXXXX`
outputFile=`mktemp /tmp/summarize_tree_output.XXXXX`

tar -zxf ../test/summarize_tree/test_data.tgz -C $testDataDir

testCVersionUsingStatOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree $testDataDir/test_data/fewer_files/ > $outputFile
    diff ../test/summarize_tree/small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingStatOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree $testDataDir/test_data/loads_o_files/ > $outputFile
    diff ../test/summarize_tree/large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingFtwOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree_ftw $testDataDir/test_data/fewer_files/ > $outputFile
    diff ../test/summarize_tree/small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testCVersionUsingFtwOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree_ftw $testDataDir/test_data/loads_o_files/ > $outputFile
    diff ../test/summarize_tree/large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testBashVersionOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree.sh $testDataDir/test_data/fewer_files/ > $outputFile
    diff ../test/summarize_tree/small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testBashVersionOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree.sh $testDataDir/test_data/loads_o_files/ > $outputFile
    diff ../test/summarize_tree/large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testRubyVersionOnSmallDirectory()
{
    rm $outputFile
    ./summarize_tree.rb $testDataDir/test_data/fewer_files/ > $outputFile
    diff ../test/summarize_tree/small_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/small_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

testRubyVersionOnLargeDirectory()
{
    rm $outputFile
    ./summarize_tree.rb $testDataDir/test_data/loads_o_files/ > $outputFile
    diff ../test/summarize_tree/large_dir_sizes $outputFile
    assertTrue "Incorrect output file, try 'diff ../test/summarize_tree/large_dir_sizes $outputFile' for more info" "[[ $? == 0 ]]"
}

# load shunit2 and run the tests.
. ../lib/shunit2

# Clean up our temporary input data files.
rm -rf $testDataDir
# We're not deleting $outputFile so students can look at its contents to aid
# in debugging problems with their code. 
# rm $outputFile
