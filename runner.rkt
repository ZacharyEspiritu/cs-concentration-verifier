#lang forge/core

(set-option! 'solver 'MiniSatProver)
(set-option! 'logtranslation 1)
(set-option! 'coregranularity 1)
(set-option! 'core_minimization 'hybrid) ; try 'hybrid if slow

(require "spec.rkt") ; the concentration requirement constraints

(require json)
(require racket/cmdline)
(require racket/stream)
(require racket/hash)

; These are a bunch of mappings from strings to Forge atom equivalents.

(define degree-type-mapping
  (hash "Sc.B." ScBDegree
        "A.B." ABDegree))

(define pathway-mapping
  (hash "Systems" SystemsPath
        "Software Principles" SoftwarePath
        "Data" DataPath
        "Artificial Intelligence/Machine Learning" MLPath
        "Theory" TheoryPath
        "Security" SecurityPath
        "Visual Computing" VisualCompPath
        "Computer Architecture" ArchitecturePath
        "Computational Biology" CompBioPath
        "Design" DesignPath
        "Self-Designed Pathway" SelfDesignedPath))

(define course-mapping
  (hash "APMA1170" APMA1170
        "APMA1200" APMA1200
        "APMA1210" APMA1210
        "APMA1360" APMA1360
        "APMA1650" APMA1650
        "APMA1655" APMA1655
        "APMA1660" APMA1660
        "APMA1670" APMA1670
        "APMA1690" APMA1690
        "APMA1710" APMA1710
        "APMA1740" APMA1740
        "CLPS1211" CLPS1211
        "CLPS1342" CLPS1342
        "CLPS1350" CLPS1350
        "CLPS1491" CLPS1491
        "CLPS1520" CLPS1520
        "CSCI0020" CSCI0020
        "CSCI0030" CSCI0030
        "CSCI0040" CSCI0040
        "CSCI0050" CSCI0050
        "CSCI0060" CSCI0060
        "CSCI0080" CSCI0080
        "CSCI0090A" CSCI0090A
        "CSCI0090B" CSCI0090B
        "CSCI0090C" CSCI0090C
        "CSCI0100" CSCI0100
        "CSCI0111" CSCI0111
        "CSCI0112" CSCI0112
        "CSCI0130" CSCI0130
        "CSCI0150" CSCI0150
        "CSCI0160" CSCI0160
        "CSCI0170" CSCI0170
        "CSCI0180" CSCI0180
        "CSCI0190" CSCI0190
        "CSCI0220" CSCI0220
        "CSCI0300" CSCI0300
        "CSCI0310" CSCI0310
        "CSCI0320" CSCI0320
        "CSCI0330" CSCI0330
        "CSCI0360" CSCI0360
        "CSCI0450" CSCI0450
        "CSCI0510" CSCI0510
        "CSCI0530" CSCI0530
        "CSCI0920" CSCI0920
        "CSCI0931" CSCI0931
        "CSCI1010" CSCI1010
        "CSCI1230" CSCI1230
        "CSCI1234" CSCI1234
        "CSCI1250" CSCI1250
        "CSCI1260" CSCI1260
        "CSCI1270" CSCI1270
        "CSCI1280" CSCI1280
        "CSCI1290" CSCI1290
        "CSCI1300" CSCI1300
        "CSCI1301" CSCI1301
        "CSCI1310" CSCI1310
        "CSCI1320" CSCI1320
        "CSCI1330" CSCI1330
        "CSCI1340" CSCI1340
        "CSCI1370" CSCI1370
        "CSCI1380" CSCI1380
        "CSCI1410" CSCI1410
        "CSCI1420" CSCI1420
        "CSCI1430" CSCI1430
        "CSCI1440" CSCI1440
        "CSCI1450" CSCI1450
        "CSCI1460" CSCI1460
        "CSCI1470" CSCI1470
        "CSCI1480" CSCI1480
        "CSCI1490" CSCI1490
        "CSCI1510" CSCI1510
        "CSCI1550" CSCI1550
        "CSCI1570" CSCI1570
        "CSCI1575" CSCI1575
        "CSCI1580" CSCI1580
        "CSCI1590" CSCI1590
        "CSCI1600" CSCI1600
        "CSCI1610" CSCI1610
        "CSCI1620" CSCI1620
        "CSCI1650" CSCI1650
        "CSCI1660" CSCI1660
        "CSCI1670" CSCI1670
        "CSCI1680" CSCI1680
        "CSCI1690" CSCI1690
        "CSCI1695" CSCI1695
        "CSCI1710" CSCI1710
        "CSCI1729" CSCI1729
        "CSCI1730" CSCI1730
        "CSCI1760" CSCI1760
        "CSCI1780" CSCI1780
        "CSCI1800" CSCI1800
        "CSCI1805" CSCI1805
        "CSCI1810" CSCI1810
        "CSCI1820" CSCI1820
        "CSCI1850" CSCI1850
        "CSCI1870" CSCI1870
        "CSCI1900" CSCI1900
        "CSCI1950E" CSCI1950E
        "CSCI1950H" CSCI1950H
        "CSCI1950I" CSCI1950I
        "CSCI1950N" CSCI1950N
        "CSCI1950Q" CSCI1950Q
        "CSCI1950R" CSCI1950R
        "CSCI1950S" CSCI1950S
        "CSCI1950T" CSCI1950T
        "CSCI1950U" CSCI1950U
        "CSCI1950V" CSCI1950V
        "CSCI1950W" CSCI1950W
        "CSCI1950X" CSCI1950X
        "CSCI1950Y" CSCI1950Y
        "CSCI1950Z" CSCI1950Z
        "CSCI1951A" CSCI1951A
        "CSCI1951B" CSCI1951B
        "CSCI1951C" CSCI1951C
        "CSCI1951D" CSCI1951D
        "CSCI1951E" CSCI1951E
        "CSCI1951G" CSCI1951G
        "CSCI1951H" CSCI1951H
        "CSCI1951I" CSCI1951I
        "CSCI1951J" CSCI1951J
        "CSCI1951K" CSCI1951K
        "CSCI1951L" CSCI1951L
        "CSCI1951M" CSCI1951M
        "CSCI1951N" CSCI1951N
        "CSCI1951O" CSCI1951O
        "CSCI1951R" CSCI1951R
        "CSCI1951S" CSCI1951S
        "CSCI1951T" CSCI1951T
        "CSCI1951U" CSCI1951U
        "CSCI1951V" CSCI1951V
        "CSCI1951W" CSCI1951W
        "CSCI1970" CSCI1970
        "CSCI1971" CSCI1971
        "CSCI1972" CSCI1972
        "CSCI2000" CSCI2000
        "CSCI2240" CSCI2240
        "CSCI2270" CSCI2270
        "CSCI2300" CSCI2300
        "CSCI2310" CSCI2310
        "CSCI2330" CSCI2330
        "CSCI2340" CSCI2340
        "CSCI2370" CSCI2370
        "CSCI2390" CSCI2390
        "CSCI2410" CSCI2410
        "CSCI2420" CSCI2420
        "CSCI2440" CSCI2440
        "CSCI2470" CSCI2470
        "CSCI2500A" CSCI2500A
        "CSCI2500B" CSCI2500B
        "CSCI2510" CSCI2510
        "CSCI2520" CSCI2520
        "CSCI2531" CSCI2531
        "CSCI2540" CSCI2540
        "CSCI2550" CSCI2550
        "CSCI2560" CSCI2560
        "CSCI2570" CSCI2570
        "CSCI2580" CSCI2580
        "CSCI2590" CSCI2590
        "CSCI2730" CSCI2730
        "CSCI2750" CSCI2750
        "CSCI2820" CSCI2820
        "CSCI2950C" CSCI2950C
        "CSCI2950E" CSCI2950E
        "CSCI2950G" CSCI2950G
        "CSCI2950J" CSCI2950J
        "CSCI2950K" CSCI2950K
        "CSCI2950L" CSCI2950L
        "CSCI2950O" CSCI2950O
        "CSCI2950P" CSCI2950P
        "CSCI2950Q" CSCI2950Q
        "CSCI2950R" CSCI2950R
        "CSCI2950T" CSCI2950T
        "CSCI2950U" CSCI2950U
        "CSCI2950V" CSCI2950V
        "CSCI2950W" CSCI2950W
        "CSCI2950X" CSCI2950X
        "CSCI2950Z" CSCI2950Z
        "CSCI2951A" CSCI2951A
        "CSCI2951B" CSCI2951B
        "CSCI2951C" CSCI2951C
        "CSCI2951D" CSCI2951D
        "CSCI2951E" CSCI2951E
        "CSCI2951F" CSCI2951F
        "CSCI2951G" CSCI2951G
        "CSCI2951H" CSCI2951H
        "CSCI2951I" CSCI2951I
        "CSCI2951J" CSCI2951J
        "CSCI2951K" CSCI2951K
        "CSCI2951L" CSCI2951L
        "CSCI2951M" CSCI2951M
        "CSCI2951N" CSCI2951N
        "CSCI2951O" CSCI2951O
        "CSCI2951P" CSCI2951P
        "CSCI2951Q" CSCI2951Q
        "CSCI2951R" CSCI2951R
        "CSCI2951S" CSCI2951S
        "CSCI2951T" CSCI2951T
        "CSCI2951U" CSCI2951U
        "CSCI2951V" CSCI2951V
        "CSCI2951W" CSCI2951W
        "CSCI2951X" CSCI2951X
        "CSCI2951Y" CSCI2951Y
        "CSCI2951Z" CSCI2951Z
        "CSCI2952A" CSCI2952A
        "CSCI2952B" CSCI2952B
        "CSCI2952C" CSCI2952C
        "CSCI2952D" CSCI2952D
        "CSCI2952E" CSCI2952E
        "CSCI2952F" CSCI2952F
        "CSCI2952G" CSCI2952G
        "CSCI2952H" CSCI2952H
        "CSCI2952I" CSCI2952I
        "CSCI2952J" CSCI2952J
        "CSCI2952K" CSCI2952K
        "CSCI2952V" CSCI2952V
        "CSCI2955" CSCI2955
        "CSCI2956F" CSCI2956F
        "CSCI2980" CSCI2980
        "DATA0080" DATA0080
        "DATA0200" DATA0200
        "DATA1030" DATA1030
        "DATA1050" DATA1050
        "DATA2040" DATA2040
        "DATA2050" DATA2050
        "DATA2080" DATA2080
        "DEVL1810" DEVL1810
        "ECON1110" ECON1110
        "ECON1130" ECON1130
        "ECON1160" ECON1160
        "ECON1620" ECON1620
        "ECON1630" ECON1630
        "ECON1640" ECON1640
        "ECON1660" ECON1660
        "ECON1870" ECON1870
        "ENGN1010" ENGN1010
        "ENGN1570" ENGN1570
        "ENGN1580" ENGN1580
        "ENGN1600" ENGN1600
        "ENGN1610" ENGN1610
        "ENGN1630" ENGN1630
        "ENGN1640" ENGN1640
        "ENGN1650" ENGN1650
        "ENGN1660" ENGN1660
        "ENGN1931I" ENGN1931I
        "ENGN2912E" ENGN2912E
        "ENGN2912M" ENGN2912M
        "MATH0100" MATH0100
        "MATH0180" MATH0180
        "MATH0200" MATH0200
        "MATH0350" MATH0350
        "MATH0520" MATH0520
        "MATH0540" MATH0540
        "MATH1010" MATH1010
        "MATH1040" MATH1040
        "MATH1060" MATH1060
        "MATH1110" MATH1110
        "MATH1130" MATH1130
        "MATH1230" MATH1230
        "MATH1260" MATH1260
        "MATH1270" MATH1270
        "MATH1410" MATH1410
        "MATH1530" MATH1530
        "MATH1540" MATH1540
        "MATH1560" MATH1560
        "MATH1610" MATH1610
        "MATH1620" MATH1620
        "MUSC1210" MUSC1210
        "NEUR1020" NEUR1020
        "NEUR1030" NEUR1030
        "NEUR1040" NEUR1040
        "NEUR1650" NEUR1650
        "NEUR1670" NEUR1670
        "NEUR1680" NEUR1680
        "PHIL1630" PHIL1630
        "PHIL1855" PHIL1855
        "PHIL1880" PHIL1880
        "PHP2630" PHP2630
        "PHP2650" PHP2650
        "PHYS1600" PHYS1600
        "PLCY1702X" PLCY1702X
        "VISA1720" VISA1720))

; Actual script starts here.

(define debug-mode (make-parameter #f))

(define (parse-json-file-path json-file-path)
  (call-with-input-file json-file-path read-json))

(define (find-requirement-with-title defs-list requirement-title)
  (first (filter (lambda (requirement-data)
                   (let ([title (hash-ref requirement-data 'title)])
                     (string=? title requirement-title))) defs-list)))

; recursively finds "type":"single-explicit"
(define (get-list-of-single-explicit-uuids requirement-data exclusion-list)
  (let* ([requirement-type (hash-ref requirement-data 'type "unknown")]
         [requirement-title (hash-ref requirement-data 'title)])
    (if (member requirement-title exclusion-list)
        empty
        (case requirement-type
          [("single-explicit" "single-narrative" "single-pattern" "non-course")
           (list (hash-ref requirement-data 'requirement_uuid))]
          [else
           ; recursively get uuids
           (let* ([defs-list
                    (hash-ref requirement-data 'requirement_definitions)]
                  [results-list
                   (map (lambda (x)
                          (get-list-of-single-explicit-uuids x exclusion-list))
                        defs-list)])
             (apply append results-list))]))))

(define (get-list-of-uuids-for-title requirement-list title exclusion-list)
  (get-list-of-single-explicit-uuids
   (find-requirement-with-title requirement-list
                                title)
   exclusion-list))

(define (build-mapping-uuid-hash requirement-list title exclusion-list)
  (foldl (lambda (x result)
           (hash-set result x title))
         (hash)
         (get-list-of-uuids-for-title requirement-list title exclusion-list)))

; TODO: Clean this messy function up
(define (preprocess-requirement-uuids plan-data)
  (let* ([defs-list (hash-ref plan-data 'program_definitions)]
         [cs-conc-def (first defs-list)]
         [requirement-list (hash-ref cs-conc-def 'requirements)]

         ; Parse lists of uuids
         [calculus-uuids
          (build-mapping-uuid-hash requirement-list
                                   "Calculus Prerequisite" empty)]
         [intro-uuids
          (build-mapping-uuid-hash requirement-list
                                   "Introductory Courses" empty)]
         [intermediate-uuids
          (build-mapping-uuid-hash requirement-list
                                   "Intermediate Courses" empty)]
         [elective-uuids
          (build-mapping-uuid-hash requirement-list
                                   "Additional Courses" empty)]
         [capstone-uuids
          (build-mapping-uuid-hash requirement-list
                                   "Capstone Course" empty)]

         ; pathway parsing
         [pathway-list
          (hash-ref (find-requirement-with-title
                     (hash-ref (find-requirement-with-title requirement-list
                                                            "Pathways")
                               'requirement_definitions)
                     "Pathways")
                    'requirement_definitions)]
         [requirements-to-ignore (list "Intermediate Courses")]
         [systems-uuids
          (build-mapping-uuid-hash pathway-list "Systems" requirements-to-ignore)]
         [software-uuids
          (build-mapping-uuid-hash pathway-list "Software Principles" requirements-to-ignore)]
         [data-uuids
          (build-mapping-uuid-hash pathway-list "Data" requirements-to-ignore)]
         [ai-ml-uuids
          (build-mapping-uuid-hash pathway-list "Artificial Intelligence/Machine Learning" requirements-to-ignore)]
         [theory-uuids
          (build-mapping-uuid-hash pathway-list "Theory" requirements-to-ignore)]
         [security-uuids
          (build-mapping-uuid-hash pathway-list "Security" requirements-to-ignore)]
         [visual-uuids
          (build-mapping-uuid-hash pathway-list "Visual Computing" requirements-to-ignore)]
         [arch-uuids
          (build-mapping-uuid-hash pathway-list "Computer Architecture" requirements-to-ignore)]
         [comp-biol-uuids
          (build-mapping-uuid-hash pathway-list "Computational Biology" requirements-to-ignore)]
         [design-uuids
          (build-mapping-uuid-hash pathway-list "Design" requirements-to-ignore)]
         [self-designed-uuids
          (build-mapping-uuid-hash pathway-list "Self-Designed Pathway" requirements-to-ignore)])
    (hash-union calculus-uuids
                intro-uuids
                intermediate-uuids
                elective-uuids
                capstone-uuids
                systems-uuids
                software-uuids
                data-uuids
                ai-ml-uuids
                theory-uuids
                security-uuids
                visual-uuids
                arch-uuids
                comp-biol-uuids
                design-uuids
                self-designed-uuids)))

(define (get-courses-rel plan-data requirement-uuid-map)
  (foldl (lambda (course-data current-hash)
           (let* ([course-name (string-append (hash-ref course-data
                                                        'subject_code)
                                              (hash-ref course-data
                                                        'course_number))]
                  [course-rel (hash-ref course-mapping course-name)]

                  [requirement-uuid (hash-ref course-data 'requirement_uuid)]
                  [requirement-name (hash-ref requirement-uuid-map requirement-uuid "")]

                  [new-hash1
                   (hash-set current-hash
                             "Courses"
                             (cons course-rel
                                   (hash-ref current-hash "Courses" empty)))]
                  [new-hash2
                   (hash-set new-hash1
                             requirement-name
                             (cons course-rel
                                   (hash-ref new-hash1 requirement-name empty)))])
             new-hash2))
         (hash)
         (hash-ref plan-data 'plan_items))) ; courses-rel

(define (get-degree-type-rel plan-data)
  (let ([degree-type-string (hash-ref (first (hash-ref plan-data
                                                       'plan_items))
                                      'degree_short)])
    (hash-ref degree-type-mapping degree-type-string)))

(define (process-json json-file-path)
  (let* ([plan-data (parse-json-file-path json-file-path)]
         [requirement-uuid-map (preprocess-requirement-uuids plan-data)]
         [courses-rel (get-courses-rel plan-data requirement-uuid-map)]
         [degree-type-rel (get-degree-type-rel plan-data)])
    (check-concentration courses-rel degree-type-rel)))

(define (get-pathways-rel-list courses-rel-map)
  (let ([pathway-rel-list
         (for/fold ([result empty])
                   ([pathway-str (hash-keys pathway-mapping)])
           (if (member pathway-str (hash-keys courses-rel-map))
               (cons (hash-ref pathway-mapping pathway-str) result)
               result))])
    pathway-rel-list))

(define-syntax-rule (make-pathway-constraint pathway-str courses-rel-map)
  (let* ([pathway-rel (hash-ref pathway-mapping pathway-str)]
         [assigned-rel (join pathway-rel assignedCourses)])
    (if (member pathway-str (hash-keys courses-rel-map))
        (= assigned-rel (let ([courses-in-path-rel (hash-ref courses-rel-map pathway-str)])
                          (when (debug-mode)
                            (printf "    ~s: ~s\n" pathway-str courses-in-path-rel))
                          (if (equal? 1 (length courses-in-path-rel)) ; note for Tim; doing this weird thing because can't use < inside of Forge macro context
                              (first courses-in-path-rel)
                              (+ courses-in-path-rel))))
        (not (some assigned-rel)))))

(define (debug-output courses-rel-map degree-type-rel)
  (printf "Courses: ~s\n" (hash-ref courses-rel-map "Courses"))
  (printf "Electives: ~s\n" (hash-ref courses-rel-map "Additional Courses"))
  (printf "Capstone: ~s\n"
          (if (hash-has-key? courses-rel-map "Capstone Course")
              (hash-ref courses-rel-map "Capstone Course")
              "n/a"))
  (printf "Pathways: ~s\n" (get-pathways-rel-list courses-rel-map)))

(define (check-concentration courses-rel-map degree-type-rel)
  (when (debug-mode)
    (debug-output courses-rel-map degree-type-rel))
  (begin
    ; This is kind of messy, but unfortunately it seems that you need to
    ; generate constraints within #:preds, otherwise the macro expansion for
    ; Forge does not work.
    (run verify-plan
         #:preds[; one Plan
                 (one Plan)
                 ; some p: Plan | ...
                 (some ([p Plan])
                       ; concentrationPlanSatisfiesRequirements[p]
                       (and (concentrationPlanSatisfiesRequirements p)
                            ; p.degreeType = ...
                            (= (join p degreeType) degree-type-rel)
                            ; p.courses = ...
                            (= (join p courses) (+ (hash-ref courses-rel-map "Courses")))
                            ; p.pathways = ...
                            (= (join p pathways) (+ (get-pathways-rel-list courses-rel-map)))
                            ; p.electives = ...
                            (= (join p electives) (+ (hash-ref courses-rel-map "Additional Courses")))
                            ; p.capstone = ... (OR) none p.capstone
                            (if (hash-has-key? courses-rel-map "Capstone Course")
                                (= (join p capstone) (first (hash-ref courses-rel-map "Capstone Course")))
                                (not (some (join p capstone))))))
                 ; This looks really messy, but it seems to because you have to
                 ; work in macro-land and so you can't fold over the list of
                 ; pathways, etc. Something to improve in the future.
                 (make-pathway-constraint "Systems" courses-rel-map)
                 (make-pathway-constraint "Software Principles" courses-rel-map)
                 (make-pathway-constraint "Data" courses-rel-map)
                 (make-pathway-constraint "Artificial Intelligence/Machine Learning" courses-rel-map)
                 (make-pathway-constraint "Theory" courses-rel-map)
                 (make-pathway-constraint "Security" courses-rel-map)
                 (make-pathway-constraint "Visual Computing" courses-rel-map)
                 (make-pathway-constraint "Computer Architecture" courses-rel-map)
                 (make-pathway-constraint "Computational Biology" courses-rel-map)
                 (make-pathway-constraint "Design" courses-rel-map)
                 (make-pathway-constraint "Self-Designed Pathway" courses-rel-map)]
         #:scope[])
    (is-sat? verify-plan)))

(command-line
 #:usage-help
 "Checks if a ASK JSON export is a valid CS concentration."
 #:once-each
 [("-d" "--debug") "Prints out some debug information"
                   (debug-mode #t)]
 #:args (json-file-path)
 (process-json json-file-path))
