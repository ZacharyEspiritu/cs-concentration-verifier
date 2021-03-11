#lang forge/core

(set-option! 'solver 'MiniSatProver)
(set-option! 'logtranslation 1)
(set-option! 'coregranularity 1)
(set-option! 'core_minimization 'hybrid) ; try 'hybrid if slow

(require "spec.rkt")
(require racket/stream)

(define bostonNeighbors (+ Boston Prov NYC)) ; (+ over a list)

(run findSource
     #:preds[(some ([v Vertex])
                   (source v))
             (= (join Boston edges) bostonNeighbors)
             (in (-> Boston Worc) edges)]
     #:scope[(Vertex 5 5)])
