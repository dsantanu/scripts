#!/usr/bin/python

"""
DETAILS     : Write a function that given an input array of integers 
	      and a desired target_sum, returns the number of combinations,
	      of any length, that add up to that target_sum. 
AUTHOR      : Santanu Das
NOTE	    : Python v2.6 or higher required (not v3.x) 
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
        print "{0} => {1}".format(pSum,tSum)

    if s >= tSum:
        return # i.e. we have reached the number

    for i in xrange(len(nArr)):
        n = nArr[i]
        remaining = nArr[i+1:]
        subset_sum_recursive(remaining,tSum,pSum + [n]) 


# Function to start recursion, with an empty list 
def subset_sum(tSum,sArr=None,sRng=None):
    
    if sRng != None: sArr = sRng
    subset_sum_recursive(sArr,tSum,list())


# Configures command-line parameter here 
def main():

    print
    import argparse, re
    parser = argparse.ArgumentParser(description='''Given an input array of integers and a desired
                                                    target_sum, returns the number of combinations, 
                                                    of any length, that adds up to that target_sum''')
    group = parser.add_mutually_exclusive_group(required=True)

    group.add_argument('-n', '--numbers',
                        help='The given array of numbers (2,3,7..n)',
                        dest='sArr', metavar='SARR')

    group.add_argument('-r', '--range',
                        help='The given range ([start,] stop[, step])',
                        dest='sRng', metavar='SRNG')

    parser.add_argument('-t', '--target',
                        help='The targeted sum',
                        dest='tSum', metavar='TSUM', required=True)

    opts = parser.parse_args()
    opts.tSum = int(opts.tSum)

    # generate the list from the string
    if opts.sArr:
        opts.sArr = map(int, re.split(r"[\W']+", opts.sArr.strip()))
    else:
        LST = map(int, re.split(r"\W+", opts.sRng.strip()))
        if len(LST) > 3:
            print "Too many argiments...."
            print "Use -h for details\n"
            sys_exit(1)
        elif len(LST) in [2,3]:
            LST[1] += 1
        else:
            LST[0] += 1
        opts.sRng = range(*LST)

    # 
    opts_dict = vars(opts)
    #print opts_dict

    chkVer = subset_sum(**opts_dict)
    sys.exit(not chkVer)


# Precessing starts here
if __name__ == "__main__":
    try: sys.exit(main())
    except KeyboardInterrupt: pass
    finally: print
