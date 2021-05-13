# Build the image
.PHONY: build
build:
	docker build -t wait-reproducer .

# Run the container using bash 5.0.3(1)-release
.PHONY: run50
run50:
	docker run -it --rm --name waiter wait-reproducer bash5.0 ./fail_to_wait.sh

# Run the container using bash 5.1.0(1)-release
.PHONY: run51
run51:
	docker run -it --rm --name waiter wait-reproducer bash5.1 ./fail_to_wait.sh

# Send in a HUP signal, which should only print a message and not exit the
# container. This fails on Bash 5.1.0.
.PHONY: send-sighup
send-signal:
	docker kill --signal=HUP waiter

# Example of what happens if only the child process is killed.
.PHONY: kill-sleep
kill-sleep:
	docker exec -it waiter bash -c 'kill -15 $$(cat ./child_pid)'
