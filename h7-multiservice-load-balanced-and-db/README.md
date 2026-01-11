# Developed and tested on Almalinux9.1

## How to run:
	## -- sh 1-create_env.sh (pronmt for postgres password  ---DO NOT USE special characters---)
	## -- sh 2-create_certs.sh (create self-sign certs for https)
	## -- sh 3-start_app.sh (start app from docker compose up --build -d)
	## -- sh 4-test_app.sh (test backend)

### Bonus Challenges
	- **Health Checks:** DONE (docker stop backend-2 )
	- **Sticky Sessions:** NOT DONE (not feasible on the same NAT) (can be added)
	- **HTTPS:** DONE
	- **Persistent Data:** DONE (added PostgreSQL container)
	- **More Complex API:** DONE (POST & DELETE buttons)
	- **http redirect to https:** DONE (nice to have -- Bonus to Bonus)

#### Improvements (to do..)
	-- The database password can contain special characters, e.g., @!#