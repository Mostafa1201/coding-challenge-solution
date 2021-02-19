run: clean compile
	./challenge

clean:
	rm -rf challenge challenge.dSYM

compile:
	clang -Wall -g -v  -lobjc -framework Foundation \
		InterviewChallengeUtilities.m challenge.m -o challenge
