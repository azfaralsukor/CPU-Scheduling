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
	wt[i]=0
	for ((j=0; j<i; j++))
	do
		wt[i]=`expr ${wt[i]} + ${bt[j]}`
	done
done
 
echo "Process   Arrival Time   Burst Time   Priority   Waiting Time   Turnaround Time"
 				
for ((i=0; i<n; i++)) do
	tat[i]=`expr ${bt[i]} + ${wt[i]}`
	twt=`expr ${twt[i]} + ${wt[i]}`
	ttat=`expr $ttat + ${tat[i]}`
	echo "  P["$i"]          "${at[i]}"             "${bt[i]}"          "${p[i]}"                "${wt[i]}"              "${tat[i]}
	total=${tat[i]}
done    

echo
echo "~~{Gantt Chart}~~"
echo

echo "Time       Process"

count=0
prior=7
previous=-1

while [ $count -ne $total ]; do
	for (( i = 0; i < n; i++ )); do
		if [ ${bt[i]} -gt 0 ]; then
			if [ ${at[i]} -le $count ]; then
				if [ ${p[i]} -lt $prior ]; then
					prior=${p[i]}
					processing=$i
				fi
			elif [ ${at[i]} -le ${at[$processing]} ]; then
				if [ ${p[i]} -lt $prior ]; then
					prior=${p[i]}
					processing=$i				
				fi
			fi
		fi
	done
	
	if [ $previous -ne $processing ]; then
		echo $count"            P["$processing"]" 
		previous=$processing
	fi

	if [ ${bt[$processing]} -gt 1 ]; then
		bt[$processing]=`expr ${bt[$processing]} - 1`
	else
		prior=7
		p[$processing]=7
	fi
	let count+=1
done

	echo $total"            END"

echo 
echo
awk "BEGIN {printf \"Average Waiting Time: %.2f\n\", $twt/$n}"
awk "BEGIN {printf \"Average Turnaround Time: %.2f\n\", $ttat/$n}"
