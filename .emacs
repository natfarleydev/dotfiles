(global-set-key (kbd "C-<return>") 'save-buffer)
(set-face-attribute 'default nil :height 80)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(el-get 'sync)

(tool-bar-mode -1)
(menu-bar-mode -1)

;; Org mode stuff
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)


;; ;; Because I love vim too much
;; (add-to-list 'load-path "~/.emacs.d/evil")
;; (require 'evil)
;; (evil-mode 1)

;; (define-key evil-insert-state-map "k" #'cofi/maybe-exit)

;; (evil-define-command cofi/maybe-exit ()
;;   :repeat change
;;   (interactive)
;;   (let ((modified (buffer-modified-p)))
;;     (insert "k")
;;     (let ((evt (read-event (format "Insert %c to exit insert state" ?j)
;;                nil 0.5)))
;;       (cond
;;        ((null evt) (message ""))
;;        ((and (integerp evt) (char-equal evt ?j))
;;     (delete-char -1)
;;     (set-buffer-modified-p modified)
;;     (push 'escape unread-command-events))
;;        (t (setq unread-command-events (append unread-command-events
;;                           (list evt))))))))

(load-theme 'wheatgrass)


;; from 

    ;; This could be made portable but I'm not interested in that at the
    ;; moment so it's git-only.

    (defun vc-push-or-pull ()
      "`vc-push' if given an argument, otherwise `vc-pull'"
      (interactive)
      (if current-prefix-arg
          (vc-push)
          (vc-pull)))

    (defun vc-push ()
      "Run git-push on the current repository, does a dry-run unless
    given a prefix arg."
      (interactive)
      (shell-command "git push"))

    (defun vc-pull ()
      "Run git-pull on the current repository."
      (interactive)
      (shell-command "git pull"))

    ;; vc.el - add commands to push and pull with git
    (progn
      (define-key vc-prefix-map "p" 'vc-push))

;; (add-to-list 'auto-mode-alist '("\\.markdown\\'" . text-mode))
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)
;; (add-hook 'text-mode-hook
;;           (lambda ()
;;             (set-fill-column 65)))

(add-hook 'c++-mode-hook 'turn-on-auto-fill)
(add-hook 'c++-mode-hook
          (lambda ()
            (set-fill-column 80)))

 (setq column-number-mode t)

(fset 'fix-pandoc-table-with-split-window
   [?\C-  ?\C-s ?\C-q ?\C-j ?\C-q ?\C-j ?\C-b ?\C-b ?\M-w ?\C-x ?o ?\C-y tab ?\C-x ?o ?\C-n ?\C-n ?\C-a])

(global-set-key (kbd "C-#") 'fix-pandoc-table-with-split-window)

;; from stackoverflow question
(eval-after-load 'dired
  '(define-key dired-mode-map (kbd "C-c Q") 'my-dired-do-query-replace))

(defun my-dired-do-query-replace (from to &optional delimited)
  "Do `query-replace' of FROM with TO, on all marked files.
Third arg DELIMITED (prefix arg) means replace only word-delimited matches.
If you exit (\\[keyboard-quit], RET or q), you can resume the query replace
with the command \\[tags-loop-continue]."
  (interactive
   (let ((common
          (query-replace-read-args
           "Query replace in marked files" nil t)))
     (list (nth 0 common) (nth 1 common) (nth 2 common))))
  (require 'dired-aux)
  (dolist (file (dired-get-marked-files nil nil 'dired-nondirectory-p))
    (let ((buffer (get-file-buffer file)))
      (if (and buffer (with-current-buffer buffer
                        buffer-read-only))
          (error "File `%s' is visited read-only" file))))
  (my-tags-query-replace
   from to delimited '(dired-get-marked-files nil nil 'dired-nondirectory-p)))

(defun my-tags-query-replace (from to &optional delimited file-list-form)
  "Do `query-replace' of FROM with TO on all files listed in tags table.
Third arg DELIMITED (prefix arg) means replace only word-delimited matches.
If you exit (\\[keyboard-quit], RET or q), you can resume the query replace
with the command \\[tags-loop-continue].
Fourth arg FILE-LIST-FORM non-nil means initialize the replacement loop.
Fifth and sixth arguments START and END are accepted, for compatibility
with `query-replace', and ignored.

If FILE-LIST-FORM is non-nil, it is a form to evaluate to
produce the list of files to search.

See also the documentation of the variable `tags-file-name'."
  (interactive (query-replace-read-args "Tags query replace" nil t))
  (require 'etags)
  (setq tags-loop-scan `(let ,(unless (equal from (downcase from))
                                '((case-fold-search nil)))
                          (if (search-forward ',from nil t)
                              ;; When we find a match, move back
                              ;; to the beginning of it so perform-replace
                              ;; will see it.
                              (goto-char (match-beginning 0))))
        tags-loop-operate `(perform-replace ',from ',to t nil ',delimited
                                            nil multi-query-replace-map))
  (tags-loop-continue (or file-list-form t)))

;; aend of stackoverflow thing



(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook (function turn-on-reftex))
(setq reftex-plug-into-AUCTeX t)

(add-to-list 'load-path "/home/nasfarley88/.emacs.d/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/home/nasfarley88/.emacs.d//ac-dict")
(ac-config-default)


(require 'pomodoro)
(require 'ac-math)

(require 'rainbow-delimiters)
(global-rainbow-delimiters-mode)

(add-to-list 'ac-modes 'latex-mode)   ; make auto-complete aware of {{{latex-mode}}}

(defun ac-latex-mode-setup ()         ; add ac-sources to default ac-sources
  (setq ac-sources
     (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
               ac-sources))
)

(add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)
(ac-flyspell-workaround)

(setq ispell-program-name "aspell")
(setq ispell-dictionary "british")

;; So that RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands '("bibliography" "nobibliography" "addbibresource"))
  ;; Biber under AUCTeX
  (defun TeX-run-Biber (name command file)
    "Create a process for NAME using COMMAND to format FILE with Biber." 
   (let ((process (TeX-run-command name command file)))
      (setq TeX-sentinel-function 'TeX-Biber-sentinel)
      (if TeX-process-asynchronous
          process
        (TeX-synchronous-sentinel name file process))))

  (defun TeX-Biber-sentinel (process name)
    "Cleanup TeX output buffer after running Biber."
    (goto-char (point-max))
    (cond
     ;; Check whether Biber reports any warnings or errors.
     ((re-search-backward (concat
                           "^(There \\(?:was\\|were\\) \\([0-9]+\\) "
                           "\\(warnings?\\|error messages?\\))") nil t)
      ;; Tell the user their number so that she sees whether the
      ;; situation is getting better or worse.
      (message (concat "Biber finished with %s %s. "
                       "Type `%s' to display output.")
               (match-string 1) (match-string 2)
               (substitute-command-keys
                "\\\\[TeX-recenter-output-buffer]")))
     (t
      (message (concat "Biber finished successfully. "
                       "Run LaTeX again to get citations right."))))
    (setq TeX-command-next TeX-command-default))

(eval-after-load "tex"
  '(add-to-list 'TeX-command-list '("Biber" "biber %s" TeX-run-Biber nil t :help "Run Biber"))
  )


(eval-after-load "tex"
  '(add-to-list 'TeX-command-list
     		'("XeLaTeX" "xelatex -interaction=nonstopmode %s"
		  TeX-run-command t t :help "Run xelatex") t))

(setq load-path (append (list (expand-file-name "~/site-lisp")) load-path))


;; mobileorgstuffs
;; Set to the location of your Org files on your local system
(setq org-directory "~/Dropbox/org")
;; Set to the name of the file where new notes will be stored
(setq org-mobile-inbox-for-pull "~/Dropbox/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/mobileOrg")


;; (global-auto-revert-mode t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-math-abbrev-prefix ";")
 '(LaTeX-math-list (quote ((35 "#" "#" nil))))
 '(TeX-PDF-mode t)
 '(TeX-engine (quote default))
 '(custom-enabled-themes (quote (wheatgrass)))
 '(fill-column 80)
 '(flyspell-issue-message-flag nil)
 '(org-agenda-files (quote ("~/Dropbox/org/shoppingList.org" "~/Dropbox/org/test.org")))
 '(reftex-cite-format (quote natbib)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
