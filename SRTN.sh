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

    while [ "${at[i]}" -lt 0 ]
	do
	echo "Error. Arrival Time can't be less than zero. Please re-enter."
	printf "Arrival Time: "
	read at[i]
	done
    
    printf "Burst Time  : "
	read bt[i]

    while [ "${bt[i]}" -lt 1 ]
	do
	echo "Error. Burst Time can't be less than one. Please re-enter."
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
	srtn_bt[i]=${bt[i]}
	srtn_p[i]=${p[i]}
	total=`expr $total + ${bt[i]}`
done

echo
echo "~~{Shortest Remaining Time Next Gantt Chart}~~"
echo

echo "Time       Process"

count=0
previous=-1
processing=-1

while [ $count -ne $total ]; do
	for (( i = 0; i < n; i++ )); do
		if [ ${srtn_bt[i]} -gt 0 ]; then
			if [ ${at[i]} -le $count ]; then
				if [ $processing -eq -1 ]; then
					processing=$i
				elif [ ${srtn_bt[i]} -lt ${srtn_bt[$processing]} ]; then
					processing=$i
				fi
			elif [ ${at[i]} -le ${at[$processing]} ]; then
				if [ ${srtn_bt[i]} -lt ${srtn_bt[$processing]} ]; then
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

	if [ ${srtn_bt[$processing]} -gt 1 ]; then
		srtn_bt[$processing]=`expr ${srtn_bt[$processing]} - 1`
	else
		srtn_bt[$processing]=9999999999
		srtn_ft[$processing]=`expr $count + 1`
	fi
	let count+=1
done
	echo $total"            END"

echo "Process   Arrival Time   Burst Time   Priority   Waiting Time   Turnaround Time"
 				
for ((i=0; i<n; i++)) do
	wt[i]=`expr ${srtn_ft[i]} - ${at[i]} - ${bt[i]}`
	tat[i]=`expr ${srtn_ft[i]} - ${at[i]}`
	twt=`expr $twt + ${wt[i]}`
	ttat=`expr $ttat + ${tat[i]}`
	echo "  P["$i"]          "${at[i]}"             "${bt[i]}"          "${p[i]}"                "${wt[i]}"              "${tat[i]}
done    

echo 
awk "BEGIN {printf \"Average Waiting Time: %.2f\n\", $twt/$n}"
awk "BEGIN {printf \"Average Turnaround Time: %.2f\n\", $ttat/$n}"
