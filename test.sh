good_files="good/*"
echo "=========================CORRECT==========================="
for good in $good_files
do
	echo $good
	MIML/Test -s $good > /dev/null
	if [[ $? -ne 0 ]]; then
		echo "Failed on correct program"
		MIML/Test $good
    	exit 1
	fi
done

bad_files="bad/*"
echo "==========================WRONG============================"
for bad in $bad_files
do
	echo $bad
	MIML/Test -s $bad > /dev/null
	if [[ $? -ne 1 ]]; then
		echo "Parsed incorrect program"
		MIML/Test $bad
    	exit 1
	fi
done

echo "==========================================================="
echo "========================SUCCESS============================"
echo "==========================================================="