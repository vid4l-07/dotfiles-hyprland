# Prompt izquierdo
function fish_prompt
	echo ""

	set -l last_status $status
    set -l normal (set_color normal)
    set -l status_color (set_color normal)
    set -l cwd_color (set_color $fish_color_cwd)
	set -l red (set_color red)
	set -l yellow (set_color yellow)
	set -l pwd (set_color $fish_color_redirection)
	set -l prompt (set_color blue)
    set -l prompt_status ""
	set -l last_status $status

	echo -n $prompt"愛" $normal"["(prompt_login)"]" $pwd(prompt_pwd)

	echo ""
    set_color green
    echo -n "❯ "

	if functions -q fish_is_root_user; and fish_is_root_user
		if set -q fish_color_cwd_root
				set cwd_color (set_color $fish_color_cwd_root)
		end
		set suffix '#'
	end
end

# Prompt derecho
function fish_right_prompt
# Git
# set_color brblack
# git rev-parse --abbrev-ref HEAD 2>/dev/null; echo -n ' '
# set_color normal
	set -g __fish_git_prompt_show_informative_status 1
	set -g __fish_git_prompt_showuntrackedfiles 1
    set -g __fish_git_prompt_showcolorhints 1
	set -g __fish_git_prompt_showdirtystate 1

    set -g __fish_git_prompt_color_branch brblack
    set -g __fish_git_prompt_color_upstream_ahead green
    set -g __fish_git_prompt_color_upstream_behind red
    set -g __fish_git_prompt_color_dirtystate red
    set -g __fish_git_prompt_color_cleanstate green
	set -g __fish_git_prompt_color_stagedstate yellow

    set -g __fish_git_prompt_char_untrackedfiles "?"
	set -g __fish_git_prompt_char_dirtystate "x"
	set -g __fish_git_prompt_char_stagedstate "+"

	set -g __fish_git_prompt_char_stateseparator " "

	set git_info (__fish_git_prompt)
	set git_info (string replace -a "(" "" (string replace -a ")" "" "$git_info"))

    echo -n " "
    echo -n $git_info " "

end
