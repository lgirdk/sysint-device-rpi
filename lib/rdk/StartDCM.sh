#!/bin/sh
##########################################################################
# If not stated otherwise in this file or this component's Licenses.txt
# file the following copyright and licenses apply:
#
# Copyright 2018 RDK Management
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
##########################################################################
#
##################################################################
## Script to start Device Configuration Management script
## Author: Ajaykumar/Shakeel/Suraj
##################################################################
. /etc/include.properties

                                                                         
if [ -f "$RDK_PATH/DCMscript.sh" ]                                        
then                                                                      
    sh /lib/rdk/DCMscript.sh $DCM_LOG_SERVER $DCM_LOG_SERVER_URL $LOG_SERVER 0 1  >> /rdklogs/logs/telemetry.log &
    sleep 10                                                                                                      
    fileRetryCount=0                                                                                              
    while [ $fileRetryCount -ne 37 ]                                                                              
    do                                                                                                            
       echo "Trying to check if rtl_json files exists ..."                                                        
       if [ -f "/nvram/rtl_json.txt" ]; then                                                                      
         echo "files exists !!!!..."                                                                              
         #sh $RDK_PATH/DCMscript-log.sh $DCM_LOG_SERVER $DCM_LOG_SERVER_URL $LOG_SERVER 0 1  >> /rdklogs/logs/logupload.log &
         delimnr=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | tr -dc ':' |wc -c`                     
         echo "number of deli:"$delimnr                                                                                      
         delimnr=$((delimnr - 1))                                                                                            
         TFTPIP=`cat /tmp/DCMSettings.conf | grep -i urn:settings:TelemetryProfile | cut -d ":" -f$delimnr | cut -d '"' -f 2`
         echo "TFTPIP:"$TFTPIP                                                                                               
         sh $RDK_PATH/uploadSTBLogs.sh $TFTPIP 1 1 1 0 0 &                                                                   
         break                                                                                                               
       else                                                                                                                  
         echo "still file is not there sleep for 5 sec"$fileRetryCount                                                       
         sleep 5                                                                                                             
       fi                                                                                                                    
       fileRetryCount=`expr $fileRetryCount + 1`                                                                             
    done                                                                                                                     
else                                                                                                                         
    echo "$RDK_PATH/DCMscript.sh file not found."                                                                            
fi                             
