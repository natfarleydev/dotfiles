((color-theme status "installed" recipe
	      (:name color-theme :description "An Emacs-Lisp package with more than 50 color themes for your use. For questions about color-theme" :website "http://www.nongnu.org/color-theme/" :type http-tar :options
		     ("xzf")
		     :url "http://download.savannah.gnu.org/releases/color-theme/color-theme-6.6.0.tar.gz" :load "color-theme.el" :features "color-theme" :post-init
		     (progn
		       (color-theme-initialize)
		       (setq color-theme-is-global t))))
 (color-theme-chocolate-rain status "installed" recipe
			     (:name color-theme-chocolate-rain :description "Chocolate rain color theme for Emacs based on Ludvig Widman's Choco TextMate theme" :type github :pkgname "marktran/color-theme-chocolate-rain" :depends color-theme :prepare
				    (autoload 'color-theme-chocolate-rain "color-theme-chocolate-rain" "color-theme: chocolate-rain" t)))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :info "." :load "el-get.el")))
