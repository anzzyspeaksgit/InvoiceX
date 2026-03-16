-include .env

.PHONY: all test clean deploy-testnet build format lint

all: clean build test

# Clean the repo
clean:
	forge clean

# Build the contracts
build:
	forge build

# Run tests
test:
	forge test -vvv

# Format code
format:
	forge fmt

# Run coverage
coverage:
	forge coverage --report summary

# Deploy to BNB Testnet (requires private key in shared wallet or .env)
deploy-testnet:
	./deploy.sh
