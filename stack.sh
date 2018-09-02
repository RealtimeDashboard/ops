#!/bin/bash
set -Eeuo pipefail

# Commands
CREATE="CREATE"
UPDATE="UPDATE"
DELETE="DELETE"
NONE="NONE"

#Current Selection
command=$NONE
stackname=""
template=""


function validateCommand(){
    if [ "$command" != "$NONE" ]; then
        echo "Cannot select multiple CF commands"
        exit
    fi
}

while getopts "hcuds:t:" OPTION; do
	case ${OPTION} in
		c)
		    validateCommand
		    command=$CREATE
			;;
        u)
            validateCommand
            command=$UPDATE
            ;;
        d)
            validateCommand
            command=$DELETE
            ;;
		s)
		    stackname=$OPTARG
			echo "Stack Name is $stackname"
			;;
        h)
            ;;
        t)
		    template=$OPTARG
            echo "template body $template"
            ;;
		\?)
			echo "Used for the help menu"
			exit
			;;
	esac
done

if [ "$stackname" = "" ]; then
    echo "Please provide a stack name"
    exit
fi

case $command in
    $CREATE)
        echo "Creating your stack"
        aws cloudformation create-stack --stack-name $stackname --template-body file://./cf/$template.yaml
        ;;
    $DELETE)
        echo "DELETE your stack"
        aws cloudformation delete-stack --stack-name $stackname
        ;;
    $UPDATE)
        echo "UPDATE your stack"
        aws cloudformation update-stack --stack-name $stackname --template-body file://./cf/$template.yaml
        ;;
esac
