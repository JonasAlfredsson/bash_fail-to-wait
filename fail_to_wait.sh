# Listen to some common signals to make interactive mode nicer.
trap "exit" TERM INT QUIT

# Print the version of bash currently executing.
echo -e "\n$(${BASH} --version | head -n 1)\n"

# Create a trap that listens to SIGHUP and just prints a message that such a
# signal is received.
trap 'echo "Received SIGHUP"' HUP

# Create a child process we can wait for, and store it a file as well.
sleep 5m &
child_pid=$!
echo "A child process with PID ${child_pid} has now started"
echo "${child_pid}" > ./child_pid

# The sleep process is now our child, and as a parent we will wait for it to
# exit. When it exits we will want use the same status code. The loop is
# necessary since the HUP trap will make any "wait" return immediately when
# triggered, and to not exit the entire program we will have to wait on the
# original PID again.
loop_iteration=0
while [ -z "${exit_code}" ] || [ "${exit_code}" = "129" ]; do
    echo "loop_iteration: ${loop_iteration}"
    echo "Pre signal code: ${exit_code}"
    wait -n ${child_pid}
    exit_code=$?
    echo "Post signal code: ${exit_code}"
    loop_iteration=$((loop_iteration+1))
done
exit ${exit_code}
