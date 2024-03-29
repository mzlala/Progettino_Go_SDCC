CONFIG_FILE := ./configuration/config.json
#LOAD_BALANCER := $(shell jq -r .addressLoadBalancer $(CONFIG_FILE)) #inutile
SERVER_ADDRESSES := $(shell jq -r .addressServers[] $(CONFIG_FILE))
NUMBER_OF_SERVERS := $(shell jq -r .numberOfServers $(CONFIG_FILE))

windows:
	cd .\main && \
	$(foreach addr, $(SERVER_ADDRESSES), start go run .\server.go $(addr) &&) \
	start go run .\loadBalancer.go && \
	start go run .\client.go && \
	echo "Avviate ulteriori shell"

unix:
	cd ./main && \
    	{ \
    		$(foreach addr, $(SERVER_ADDRESSES), \
    			x-terminal-emulator -e "go run ./server.go $(addr)" &) \
    		x-terminal-emulator -e "go run ./loadBalancer.go" & \
    		x-terminal-emulator -e "go run ./client.go" & \
    	};