#!/bin/bash

sudo apt-get install -y figlet
sudo apt-get install toilet -y
clear



# toilet -f ivrit 'Flood Hault' | boxes -d cat -a hc -p h8 | lolcat
# echo -e "Code - Shell script\nhttps://github.com/sujayadkesar\n" | boxes -d parchment
toilet -F metal -f ivrit 'Flood Hault' | boxes -d cat -a hc -p h8 | sed '$a\'$'\n'"Code - Shell script\nhttps://github.com/sujayadkesar" | boxes -d parchment
echo -e "\n"
PS3="select an option# "
options=("Start Snort in packet capture mode" "Stop Snort" "Monitor Snort alert log" "View current configuration" "Modify configuration" "Display Snort status" "Exit")

# Configuration settings
SNORT_CONF=/etc/snort/snort.conf
OUTPUT_DIR=/var/log/snort
PACKET_COUNT=500
ALERT_THRESHOLD=5

# Snort process ID
SNORT_PID=""

select opt in "${options[@]}"
do
  case $opt in
    "Start Snort in packet capture mode")
      # Start Snort in packet capture mode and log to file
      snort -A console -q -u snort -g snort -c $SNORT_CONF -l $OUTPUT_DIR -P 2>&1 > /dev/null &
      SNORT_PID=$!
      echo "Snort started in packet capture mode with PID: $SNORT_PID"
      ;;
    "Stop Snort")
      # Stop Snort
      if [ -n "$SNORT_PID" ]; then
        kill $SNORT_PID
        echo "Snort stopped"
        SNORT_PID=""
      else
        echo "Snort is not running"
      fi
      ;;
    "Monitor Snort alert log")
      # Monitor the Snort alert log for DoS/DDoS attacks
      tail -f $OUTPUT_DIR/alert | while read line
      do
        count=$(echo $line | grep -c 'DDoS\|DoS')
        if [ $count -ge $ALERT_THRESHOLD ]
        then
          echo -e "\n  Possible DoS/DDoS attack detected: $line" # | mail -s "DoS/DDoS Attack Alert" sujayadkesar2002@gmail.com
        fi
      done
      ;;
    "View current configuration")
      # Display the current configuration settings
      echo "Current configuration settings:"
      echo "Snort configuration file: $SNORT_CONF"
      echo "Output directory: $OUTPUT_DIR"
      echo "Packet count: $PACKET_COUNT"
      echo "Alert threshold: $ALERT_THRESHOLD"
      ;;
    "Modify configuration")
      # Allow the user to modify configuration settings
      echo "Modify configuration settings:"
      read -p "Snort configuration file ($SNORT_CONF): " snort_conf
      if [ -n "$snort_conf" ]; then
        SNORT_CONF="$snort_conf"
      fi
      read -p "Output directory ($OUTPUT_DIR): " output_dir
      if [ -n "$output_dir" ]; then
        OUTPUT_DIR="$output_dir"
      fi
      read -p "Packet count ($PACKET_COUNT): " packet_count
      if [ -n "$packet_count" ]; then
        PACKET_COUNT="$packet_count"
      fi
      read -p "Alert threshold ($ALERT_THRESHOLD): " alert_threshold
      if [ -n "$alert_threshold" ]; then
        ALERT_THRESHOLD="$alert_threshold"
      fi
      echo "Configuration settings updated"
      ;;
    "Display Snort status")
      # Display the status of the Snort process
      if [ -n "$SNORT_PID" ]; then
        echo "Snort is running with PID: $SNORT_PID"
      else
        echo "Snort is not running"
      fi
      ;;
    "Exit")
      break
      ;;
    *)
      echo "Invalid option"
      ;;
  esac
done
