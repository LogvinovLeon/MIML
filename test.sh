make
good_files="good/*.miml"
echo "=========================CORRECT==========================="
for good in $good_files
do
	echo $good
	./interpreter $good
	if [[ $? -ne 0 ]]; then
		echo "Failed to interpret correct program"
		./interpreter $good
    	exit 1
	fi
done

bad_files="bad/*.miml"
echo "==========================WRONG============================"
for bad in $bad_files
do
	echo $bad
	./interpreter $bad
	if [[ $? -ne 1 ]]; then
		echo "Parsed incorrect program"
		./interpreter $bad
    	exit 1
	fi
done
echo "========================SUCCESS============================"