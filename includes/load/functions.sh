#!/bin/bash
# Functions and parameters

# $1 -> Path to the folder to create.
CreateFolder(){
    if [ -z "$1" ]; then
        echo "Folder path required as first parameter."
        return;
    fi

    if [ ! -d "$1" ]; then
        sudo mkdir -p $WEB_DIRECTORY
    fi    
}

# $1 -> Text to write
# $2 -> File path to write it in.
WriteLine()
{
    if [ -z "$1" ] then
        echo "Text to write required as first parameter."
    fi

    if [ -z "$2" ] then
        echo "File path where to write required as second parameter."
    fi

    echo "$1" | sudo tee --append $2 > /dev/null
}

#DEFAULT=default                             # Default param value.

#func2 () {
#   if [ -z "$1" ] then
#     echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
#   else
#     echo "-Parameter #1 is \"$1\".-"
#   fi
#
#   variable=${1-$DEFAULT}                   #  What does
#   echo "variable = $variable"              #+ parameter substitution show?
#                                            #  ---------------------------
#                                            #  It distinguishes between
#                                            #+ no param and a null param.
#
#   if [ "$2" ]
#   then
#     echo "-Parameter #2 is \"$2\".-"
#   fi
#
#   return 0
#}
#
#echo "Nothing passed."   
#func2                          # Called with no params
#echo "Zero-length parameter passed."
#func2 ""                       # Called with zero-length param
#echo "Null parameter passed."
#func2 "$uninitialized_param"   # Called with uninitialized param
#echo "One parameter passed."   
#func2 first           # Called with one param
#echo "Two parameters passed."   
#func2 first second    # Called with two params
#echo "\"\" \"second\" passed."
#func2 "" second       # Called with zero-length first parameter