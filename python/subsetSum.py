#!/usr/bin/python
"""
DETAILS	: Given an input array of integers and a desired target_sum, 
	  calculates the number of combinations, of any length, that 
	  add up to that target_sum. 
AUTHOR	: r.santanu.das@gmail.com
USAGE	: python subsetSum.py -n <3,5,6,7...> -t <int> 
NOTE	: This is an NP problem; http://en.wikipedia.org/wiki/Subset_sum_problem
	  (Need Python v2.7 or higher)
"""

import sys

## Exit with return code
def sys_exit(n):
    sys.stdout.flush()
    sys.exit(int(n))


# The base function to do the actual calculation 
def subset_sum_recursive(nArr,tSum,pSum):

    s = sum(pSum)
  
    #check if the pSum (partial_sum) is equals to tSum (target_sum)
    if s == tSum:
        print "%s => %s" % (pSum,tSum)

    if s >= tSum:
        return # i.e. we have reached the number

    for i in range(len(nArr)):
        n = nArr[i]
        remaining = nArr[i+1:]
        subset_sum_recursive(remaining,tSum,pSum + [n])


# Function to start recursion, with an empty list 
def subset_sum(sArr,tSum):

    subset_sum_recursive(sArr,tSum,list())


def main():

    import argparse
    parser = argparse.ArgumentParser(description='usage: %prog --opt1 <arg1> --opt2 <arg2>')

    parser.add_argument('-n', '--numbers',
                        help='The given array of numbers',
                        dest='sArr', metavar='SARR', required=True)

    parser.add_argument('-t', '--target',
                        help='The targeted sum',
                        dest='tSum', metavar='TSUM', required=True)

    opts = parser.parse_args()
    opts_dict = vars(opts)
    #print opts_dict

    for k,v in opts_dict.iteritems():
        if v is None:
            print "%s: Value is not substituted!" % k
            print "Use -h for details\n"
            sys_exit(1)
        else: pass

    opts.sArr = map(int, opts.sArr.split(','))
    opts.tSum = int(opts.tSum)

    chkVer = subset_sum(**opts_dict)
    sys.exit(not chkVer)


if __name__ == "__main__":
    try: sys.exit(main())
    except KeyboardInterrupt: pass
