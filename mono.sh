#!/bin/bash
pathDataset='./Datasets/Vaarst/slam_test'
pathExamples='../orbdock/ORB_SLAM3/Examples'
pathVocab='../ORB_SLAM3/Vocabulary'
pathHeaders='../ORB_SLAM3/include'
pathLib='../lib'


# Original
echo "Launching original with Monocular sensor"
"$pathExamples"/Monocular/mono_euroc "$pathVocab"/ORBvoc.txt ./mono_params.yaml "$pathDataset"/original ./Video_TimeStamps/Vaarst_frames.txt original


# ancuti2017color
echo "Launching ancuti2017colorwith Monocular sensor"
"$pathExamples"/Monocular/mono_euroc "$pathVocab"/ORBvoc.txt ./mono_params.yaml "$pathDataset"/ancuti2017color ./Video_TimeStamps/Vaarst_frames.txt ancuti2017color