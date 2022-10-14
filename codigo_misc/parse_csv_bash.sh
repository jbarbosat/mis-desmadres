rm matches.txt
while IFS=' ' read -r date time size path
do
    # echo "$date $time $size $path"
    echo "$path"
    num_matches=$(aws s3 cp s3://come_bucket/$path - --profile heritage_dagger| grep 'some_string' | wc -l)
    echo "$num_matches"
    if [[ $num_matches -ne "0" ]]; then
    echo $path >> matches.txt
    fi
done < exact_log_names.txt
