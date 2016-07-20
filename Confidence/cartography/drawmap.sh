#!/bin/bash
QUE=$1
KEY=mIN5BAt8Q4kciIz367SmtW9t6aWsj0oF6bafJBOd
URL=https://api.fda.gov/drug/label.json?api_key=$KEY\&search=brand_name:$QUE\&limit=100

# Keep in mind: bash indentation =/= python indentation

# Lots of inspiration from several sources on the cosine_sim function:
# http://stackoverflow.com/questions/18424228/cosine-similarity-between-2-number-lists
# http://stackoverflow.com/questions/14155669/call-python-script-from-bash-with-argument

# And the post that started me down this rabbit hole:
# http://www.gettingcirrius.com/2010/12/calculating-similarity-part-1-cosine.html
function cosine_sim {
ARG1="$1" ARG2="$2" python - <<EOF
import os
import math

def cosine_similarity(StringA,StringB):
    vectorA, vectorB = [], []
    vector_union = list(set(StringA + StringB))
    for i in range(len(vector_union)):
        vectorA.append(StringA.count(vector_union[i]))
        vectorB.append(StringB.count(vector_union[i]))
    DotProduct, MagnitudeA, MagnitudeB = 0, 0, 0
    for i in range(len(vector_union)):
        a = vectorA[i]; b = vectorB[i]
        MagnitudeA += a*a
        MagnitudeB += b*b
        DotProduct += a*b
    return DotProduct/math.sqrt(MagnitudeA*MagnitudeB)

output = cosine_similarity(os.environ['ARG1'],os.environ['ARG2'])
print output
print os.environ['ARG1']
print os.environ['ARG2']
EOF
}

if [[ -z "$QUE" ]]; then
    echo Searching openFDA without a drug name is dangerous, please specify\:
    echo \ \ \ \ \$ druginteractioncount brand_name
    exit 0
else
    DRUG=`wget --no-check-certificate -q -O - $URL`
fi

FIRST=`echo "$QUE" | sed 's/+AND+/+/g' | tr '[:upper:]' '[:lower:]'`
#SECOND=`echo "$DRUG" | grep -A 1 "\"generic_name\"\:\ \[" | grep -v "\"generic" | cut -d "\"" -f 2 | grep -v "-" | tr '[:upper:]' '[:lower:]' | sed 's/\ /+/g' | sort -u | tail -n 1`
#currently the "| tail -n 1" ensures that there will only be one output, expand in the future
SECOND=`echo "$DRUG" | grep -A 1 "\"generic_name\"\:\ \[" | grep -v "\"generic" | cut -d "\"" -f 2 | grep -v "-" |  tr '[:upper:]' '[:lower:]' | sed 's/\ /+/g' | sort -u`

echo $FIRST
echo " "
echo "$SECOND"
#SECOND may have multiple generic names (amiodarone+hydrochloride, amiodarone+hcl)
#SECOND may also be a combination of drugs (D1,+D2,+D3) --> check for commas
#SECOND may be empty if there was an error / bad data

if [[ -z "$FIRST" ]] || [[ -z "$SECOND" ]]; then
    echo Either FIRST or SECOND are empty.
    echo Contents of FIRST:
    echo "$FIRST"
    echo " "
    echo Contents of SECOND:
    echo "$SECOND"
    exit
fi

#FINALOUTPUT=$(cosine_sim $FIRST $SECOND)
#echo $FINALOUTPUT
