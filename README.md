## Usage

Make sure `runner.rkt` and `spec.rkt` are in the same directory, then from within that directory, run:

```
$ racket runner.rkt <path-to-json-file>
```

where `<path-to-json-file>` is a path to the JSON file exported from a student's ASK concentration.

You can run with the `--debug` flag to print out some additional information to show you how the concentration was parsed into the script:

```
$ racket runner.rkt --debug <path-to-json-file>

Courses: ((rel CSCI1970) (rel CSCI1970) (rel CSCI1010) (rel CSCI1010) (rel CSCI1970) (rel APMA1650) (rel APMA1650) (rel CSCI1690) (rel CSCI1670) (rel CSCI1730) (rel CSCI1230) (rel CSCI1575) (rel CSCI1570) (rel CSCI1950Y) (rel CSCI1660) (rel MATH0520) (rel MATH0520) (rel CSCI0220) (rel CSCI0220) (rel CSCI0330) (rel CSCI0330) (rel CSCI0190) (rel MATH0100))
Electives: ((rel CSCI1970) (rel CSCI1970) (rel CSCI1230) (rel CSCI1575))
Capstone: ((rel CSCI1660))
Pathways: ((rel SystemsPath) (rel TheoryPath))
    "Systems": ((rel CSCI1670) (rel CSCI1660))
    "Theory": ((rel CSCI1570) (rel CSCI1950Y))
```

To test that everything has been set up correctly (hopefully), `false.json` in the above directory should return `#f` and `true.json` in the above directory should return `#t`.

Script has been tested using Racket v7.8 on Forge version 0.13.1.
