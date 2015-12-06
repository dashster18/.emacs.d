;;; scope-mode.el -- Major mode for editing Scope scripts

;; Author: Nikesh Srivastava <niksr@microsoft.com>
;; Created: 4 Jan 2015
;; Keywords: scope-mode.el

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2 of
;; the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be
;; useful, but WITHOUT ANY WARRANTY; without even the implied
;; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
;; PURPOSE.  See the GNU General Public License for more details.

;; You should have received a copy of the GNU General Public
;; License along with this program; if not, write to the Free
;; Software Foundation, Inc., 59 Temple Place, Suite 330, Boston,
;; MA 02111-1307 USA

;;; Commentary:
;;
;; This mode is to make internal Microsoft developers lives
;; easier if they want to use Emacs to write Scope scripts.

;;; Code:
(defvar scope-mode-hook nil)
(defvar scope-mode-map
  (let ((scope-mode-map (make-keymap)))
    scope-mode-map)
    ;; TODO: Add key binding to compile script locally
    ;; TODO: Add key binding to submit script to a VC
  "Keymap for SCOPE major mode")

;;; autoload .script files using scope-mode
(add-to-list 'auto-mode-alist '("\\.script\\'" . scope-mode))
(add-to-list 'auto-mode-alist '("\\.module\\'" . scope-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Code for the syntax highlighting of the langauge
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Define language keywords, built-in data types, and aggregates
;; Pretty much anything that should be highlighted
(defvar scope-keywords
      '("EXTRACT"
     	"FROM"
     	"USING"
     	"OUTPUT"
     	"TO"
     	"VIEW"
     	"SELECT"
     	"WHERE"
     	"AND"
     	"OR"
     	"SORTED"
     	"NOT"
     	"AS"
     	"#CS"
     	"#ENDCS"
     	"#DECLARE"
     	"#IF"
     	"#ELSE"
     	"#ELSEIF"
     	"#ENDIF"
     	"#SET"
     	"UNION"
     	"INTERSECT"
     	"EXCEPT"
     	"ALL"
     	"HAVING"
     	"REFERENCE"
     	"REFERENCES"
     	"TOP"
     	"DISTINCT"
     	"DISJOINT"
     	"IF"
     	"ORDER"
     	"BY"
     	"ASC"
     	"DESC"
     	"OVER"
     	"GROUP"
     	"CROSS"
     	"APPLY"
     	"SSTREAM"
     	"STREAMSET"
     	"PATTERN"
     	"RANGE"
     	"SPARSE"
     	"LEFT"
     	"RIGHT"
     	"FULL"
     	"OUTER"
     	"INNER"
     	"JOIN"
     	"SEMIJOIN"
     	"IN"
     	"CREATE"
     	"SCHEMA"
     	"BEGIN"
     	"END"
     	"WITH"
     	"STREAMEXPIRY"
     	"PARAMS"
     	"PROCESS"
     	"PRODUCE"
     	"COMBINE"
     	"WITH"
     	"ON"
     	"MODULE"
     	"FUNC"
     	"RETURN"
     	"DEFINE"
     	"PRESORT"
     	"PARTITION"
     	"RESOURCE"
     	"EXPORT"
     	"SAMPLE"
     	"PERCENT"
     	"TIMERANGE"
     	"NULL"
     	"REDUCE"
     	"COLUMNGROUPS"
     	"CLUSTERED"
     	"BETWEEN"
     	"ROW_NUMBER"
     	"ROWSET"
     	"RANK"
     	"DENSE_RANK"
     	"NTILE"
     	"CUME_DIST"
     	"PERCENT_RANK"
     	"PERCENTILE_CONT"
     	"PERCENTILE_DISC"
     	"HASH"
    	"IMPORT"
        "ROWS"
        "UNBOUNDED"
	"PRECEDING"
	"CURRENT ROW"
	))

(defvar scope-functions
      '("ANY"
	"SUM"
	"COUNT"
	"AVG"
	"MAX"
	"MIN"
	"ARGMAX"
	"COUNTIF"
	"FIRST"
	"LAST"
	"LIST"
	"VAR"
	"STDEV"
	"REGEX"
	"LIST"
	"ARRAY_AGG"
	))

(defvar scope-types
      '("bool"
     	"byte"
     	"sbyte"
     	"char"
     	"int"
     	"uint"
     	"long"
     	"ulong"
     	"float"
     	"double"
     	"decimal"
     	"string"
     	"short"
     	"ushort"
     	"MAP"
     	"ARRAY"
	))


(defvar scope-keywords-regexp (regexp-opt scope-keywords))
(defvar scope-functions-regexp (regexp-opt scope-functions))
(defvar scope-types-regexp (regexp-opt scope-types))

(defconst scope-font-lock-keywords
  `(
    ; Note, order matters, because once colored, that part won't change.
    ; in general, longer words first

    (,scope-types-regexp . font-lock-type-face)
    (,scope-functions-regexp . font-lock-function-name-face)
    (,scope-keywords-regexp . font-lock-keyword-face)

   ; Strings that have @ in front of them + new style parameters
   ;
   ; TODO: This works for most cases, but it highlights an '@' sign by itself.
    '("@\\(\\w*\\)" . font-lock-string-face)
   )

  "Highlighting expressions for SCOPE mode.")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Code for Indentation rules
;;
;; Indentation Rules
;; ------------------
;; 1. If at beginning of buffer, indent to column 0
;; 2. If the previous line ends with an equal (and whitespace), indent
;; 3. If we see a semicolon at the end of the previous statement, de-indent based on previous line
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scope-indent-line ()
  "Indent current line as Scope code."
  (interactive)
  (indent-for-tab-command) ;; Original command
  )

(defvar scope-mode-syntax-table
  (let ((scope-mode-syntax-table (make-syntax-table)))
	
	; Comment styles are same as C++
	(modify-syntax-entry ?\/ ". 12b" scope-mode-syntax-table)
	(modify-syntax-entry ?* ". 23" scope-mode-syntax-table)
	(modify-syntax-entry ?\n "> b" scope-mode-syntax-table)
	
	scope-mode-syntax-table)
  "Syntax table for scope-mode")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Putting the mode together and exporting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun scope-mode ()
  (interactive)
  (kill-all-local-variables)
  (use-local-map scope-mode-map)
  (set-syntax-table scope-mode-syntax-table)
  ;; Set up font-lock
  (set (make-local-variable 'font-lock-defaults) '(scope-font-lock-keywords))
  ;; Register our indentation function
  ;; (set (make-local-variable 'indent-line-function) 'scope-indent-line) 
  (setq major-mode 'scope-mode)
  (setq mode-name "SCOPE")
  (run-hooks 'scope-mode-hook))


;; clear memory. no longer needed
(setq scope-keywords nil)
(setq scope-types nil)
(setq scope-functions nil)

;; clear memory. no longer needed
(setq scope-keywords-regexp nil)
(setq scope-types-regexp nil)
(setq scope-functions-regexp nil)

(provide 'scope-mode)
