#!/bin/bash

if [ -f build.console.$3.txt ]; then rm build.console.$3.txt ; fi

if [ "$3" = "" ] || ( [ "$4" != "" ] && [ "$5" = "" ] ); then echo Missing results directory, platform, label, user, and password arguments ; exit 1 ; fi

package=genericode-v1.0
thisStage=csd04wd02
prevStage=cs
targetdir=$1
platform=$2
label=$3

echo Building package for $package $thisStage...
java -Dant.home=utilities/ant -classpath db/spec-0.8/validate/xjparse.jar:utilities/ant/lib/ant-launcher.jar:db/spec-0.8/validate/saxon9he.jar:. org.apache.tools.ant.launch.Launcher -buildfile produceGenericode.xml "-Ddir=$targetdir" "-Dstage=$thisStage" "-DprevStage=$prevStage" "-Dpackage=$package" "-Dlabel=$label" "-Drealtauser=$4" "-Drealtapass=$5"  "-Dplatform=$platform"
serverReturn=$?

sleep 2
if [ ! -d $targetdir/$package-$thisStage-$label-archive-only/ ]; then mkdir $targetdir/$package-$thisStage-$label-archive-only/ ; fi
mv build.console.$label.txt $targetdir/$package-$thisStage-$label-archive-only/
echo $serverReturn         >$targetdir/$package-$thisStage-$label-archive-only/build.exitcode.$label.txt
touch                       $targetdir/$package-$thisStage-$label-archive-only/build.console.$label.txt

# reduce GitHub storage costs by zipping results and deleting intermediate files
pushd $targetdir
if [ -f $package-$thisStage-$label-archive-only.zip ]; then rm $package-$thisStage-$label-archive-only.zip ; fi
7z a $package-$thisStage-$label-archive-only.zip $package-$thisStage-$label-archive-only
if [ -f $package-$thisStage-$label.zip ]; then rm $package-$thisStage-$label.zip ; fi
7z a $package-$thisStage-$label.zip $package-$thisStage-$label
popd

if [ "$targetdir" = "target" ]
then
if [ "$platform" = "github" ]
then
if [ "$6" = "DELETE-REPOSITORY-FILES-AS-WELL" ] #secret undocumented failsafe
then
# further reduce GitHub storage costs by deleting repository files

find . -not -name target -not -name .github -maxdepth 1 -exec rm -r -f {} \;

mv $targetdir/$package-$thisStage-$label-archive-only.zip .
mv $targetdir/$package-$thisStage-$label.zip .
rm -r -f $targetdir

fi
fi
fi

exit 0 # always be successful so that github returns ZIP of results
