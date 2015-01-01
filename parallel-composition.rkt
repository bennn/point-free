#lang racket

(provide app
         join
         wind-pre
         wind-post
         wind
         wind1
         define/wind
         define/wind-pre
         define/wind-post
         define/wind1
         wind-pre*
         wind-post*
         wind*
         define/wind-pre*
         define/wind-post*
         define/wind*)

(define (app f . vs) (apply f vs))
(define ((join . fs) . vs) (apply values (map app fs vs)))

(define (wind-pre f . gs) (compose f (apply join gs)))
(define (wind-post f . gs) (compose (apply join gs) f))
(define ((wind f . gs) . hs) (apply wind-post (apply wind-pre f gs) hs))
(define (wind1 f . gs) ((apply wind f (drop-right gs 1)) (last gs)))

(define-syntax-rule (define/wind id f (pre ...) (post ...))
  (define id ((wind f pre ...) post ...)))

(define-syntax-rule (define/wind-pre id f pre ...)
  (define id (wind-pre f pre ...)))

(define-syntax-rule (define/wind-post id f post ...)
  (define id (wind-post f post ...)))

(define-syntax-rule (define/wind1 id f pre ... post)
  (define id (wind1 f pre ... post)))

(define ((join* f) . vs) (apply values (map f vs)))
(define (wind-pre* f g) (compose f (join* g)))
(define (wind-post* f g) (compose (join* g) f))
(define (wind* f g h) (wind-post* (wind-pre* f g) h))

(define-syntax-rule (define/wind* id f pre post)
  (define id (wind* f pre post)))

(define-syntax-rule (define/wind-pre* id f pre)
  (define id (wind-pre* f pre)))

(define-syntax-rule (define/wind-post* id f post)
  (define id (wind-post* f post)))