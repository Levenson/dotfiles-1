(require 'smart-mode-line)
(add-to-list 'sml/hidden-modes " yas")
(add-to-list 'sml/hidden-modes " hl-s")
(add-to-list 'sml/hidden-modes " ElDoc")
(add-to-list 'sml/hidden-modes " Paredit")
(add-to-list 'sml/hidden-modes " SliNav")
(add-to-list 'sml/hidden-modes " SliExp")
(add-to-list 'sml/hidden-modes " SP")
(add-to-list 'sml/hidden-modes " ||")
(add-to-list 'sml/hidden-modes "/s")

(sml/setup)

(sml/apply-theme 'dark)
