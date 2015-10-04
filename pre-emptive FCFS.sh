#!/bin/bash

twt=0
ttat=0
echo
printf "Enter total number of processes (3 - 10) : "
read n

    while [[ $n -lt 3 || $n -gt 10 ]]
	do
	echo "Error. Number of process must be between 3 to 10. Please re-enter."
    printf "Enter total number of processes (3 - 10) : "
	read n
	done

echo

echo "Enter Process Arrival Time, Burst Time & Priority"
for (( i=0; i<n; i++ )); do
    echo "____P["$i"]____"
    printf "Arrival Time: "
	read at[i]
    printf "Burst Time  : "
	read bt[i]

    while [ "${bt[i]}" -lt 1 ]
	do
	echo "Error. Burst Time can't be zero. Please re-enter."
	printf "Burst Time  : "
	read bt[i]
	done
    
    printf "Priority    : "
	read p[i]
	
    while [[ "${p[i]}" -lt 1 || "${p[i]}" -gt 6 ]]
	do
	echo "Error. Priority value range is only from 1 to 7. Please re-enter."
    printf "Priority    : "
	read p[i]
	done
    
	echo
done

for ((i=0; i<n; i++)) do
	fcfs_bt[i]=${bt[i]}
	fcfs_p[i]=${p[i]}
	total=`expr $total + ${bt[i]}`
done
	tat[i]=`expr ${fcfs_ft[i]} - ${at[i]}`
	twt=`expr $twt + ${wt[i]}`
	ttat=`expr $ttat + ${tat[i]}`
	echo "  P["$i"]          "${at[i]}"             "${bt[i]}"          "${p[i]}"                "${wt[i]}"              "${tat[i]}

echo
echo "~~{Pre-Emptive First Come First Serve Gantt Chart}~~"
echo

echo "Time       Process"

count=0
prior=7
previous=-1

while [ $count -ne $total ]; do
	for (( i = 0; i < n; i++ )); do
		if [ ${fcfs_bt[i]} -gt 0 ]; then
			if [ ${at[i]} -le $count ]; then
				if [ ${fcfs_p[i]} -lt $prior ]; then
					prior=${fcfs_p[i]}
					processing=$i
				fi
			elif [ ${at[i]} -le ${at[$processing]} ]; then
				if [ ${fcfs_p[i]} -lt $prior ]; then
					prior=${fcfs_p[i]}
					processing=$i				
				fi
			fi
		fi
	done
	
	if [ $previous -ne $processing ]; then
		if [ ${at[$processing]} -gt $count ]; then
			count=${at[$processing]}
			total=`expr $total + ${at[$processing]}`
		fi
		echo $count"            P["$processing"]" 
		previous=$processing
	fi

	if [ ${fcfs_bt[$processing]} -gt 1 ]; then
		fcfs_bt[$processing]=`expr ${fcfs_bt[$processing]} - 1`
	else
		fcfs_ft[$processing]=`expr $count + 1`
		prior=7
		fcfs_p[$processing]=7
	fi
	let count+=1
done
	echo $total"            END"

echo "Process   Arrival Time   Burst Time   Priority   Waiting Time   Turnaround Time"
 				
for ((i=0; i<n; i++)) do
	wt[i]=`expr ${fcfs_ft[i]} - ${at[i]} - ${bt[i]}`
	tat[i]=`expr ${fcfs_ft[i]} - ${at[i]}`
	twt=`expr $twt + ${wt[i]}`
	ttat=`expr $ttat + ${tat[i]}`
	echo "  P["$i"]          "${at[i]}"             "${bt[i]}"          "${p[i]}"                "${wt[i]}"              "${tat[i]}

done    

echo 
awk "BEGIN {printf \"Average Waiting Time: %.2f\n\", $twt/$n}"
awk "BEGIN {printf \"Average Turnaround Time: %.2f\n\", $ttat/$n}"
