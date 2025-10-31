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

    # set_color blue
    echo -n $prompt"愛" "["(prompt_login)"]" $pwd(prompt_pwd)

	set -l last_status $status
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
    set_color brblack
    git rev-parse --abbrev-ref HEAD 2>/dev/null; echo -n ' '
    set_color normal
end
