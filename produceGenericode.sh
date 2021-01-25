#!/bin/bash

if [ -f hub.console.$3.txt ]; then rm hub.console.$3.txt ; fi

if [ "$4" = "" ] || ( [ "$5" != "" ] && [ "$6" = "" ] ); then echo Missing results directory, platform, label, date-stamp, user, and password arguments ; exit 1 ; fi

package=genericode-v1.0
prevStage=csd03
label=$3

#extract the stage from the expected entity declaration in the source file
thisStage=`grep "^\\s*..ENTITY.stage " doc/genericode.xml | sed -E "s/.*stage..([^\"]+)\".*/\\1/"`
#reflect the stage in the publishing parameter file
sed -E "s/REPLACE_THIS_WITH_STAGE_STRING/$thisStage/" <raw-realta-user-parameters.xml >realta-user-parameters.xml

echo Building package for $package $thisStage...
java -Dant.home=utilities/ant -classpath db/spec-0.8/validate/xjparse.jar:utilities/ant/lib/ant-launcher.jar:db/spec-0.8/validate/saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile produceGenericode.xml -Ddir=$1 -Dstage=$thisStage -DprevStage=$prevStage -Dpackage=$package -Dlabel=$label -Ddatetimelocal=$4 -Drealtauser=$5 -Drealtapass=$6 | tee hub.console.$3.txt
serverReturn=${PIPESTATUS[0]}
echo $serverReturn >hub.exitcode.$3.txt

rm realta-user-parameters.xml

if [ -f $1/$package-$thisStage-$label-archive-only.zip ]
then
7z a $1/$package-$thisStage-$label-archive-only.zip hub.console.$3.txt hub.exitcode.$3.txt
fi

if [ ! -d $1 ]; then mkdir $1 ; fi
if [ ! -d $1/$package-$thisStage-$label ]; then mkdir $1/$package-$thisStage-$label ; fi
if [ ! -d $1/$package-$thisStage-$label/archive-only-not-in-final-distribution/ ]; then mkdir $1/$package-$thisStage-$label/archive-only-not-in-final-distribution/ ; fi
mv  hub.console.$3.txt $1/$package-$thisStage-$label/archive-only-not-in-final-distribution/
mv hub.exitcode.$3.txt $1/$package-$thisStage-$label/archive-only-not-in-final-distribution/

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $1
7z a $package-$thisStage-$label.zip $package-$thisStage-$label
popd

if [ "$1" = "target" ]
then
if [ "$2" = "github" ]
then
if [ "$7" = "DELETE-REPOSITORY-FILES-AS-WELL" ] #secret undocumented failsafe
then
# further reduce GitHub storage costs by deleting repository files

find . -not -name target -not -name .github -maxdepth 1 -exec rm -r -f {} \;
mv $1/$package-$thisStage-$label.zip .
rm -r -f $1

fi
fi
fi

exit 0 # always be successful so that github returns ZIP of results

