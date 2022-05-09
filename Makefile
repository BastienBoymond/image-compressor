##
## EPITECH PROJECT, 2022
## Untitled (Workspace)
## File description:
## Makefile
##

local_path	:=	$(shell stack path --local-install-root)
executable	:=	$(local_path)/bin
NAME	=	imageCompressor

all:
	@echo "Compiling..."
	@stack build
	@echo "Compilation done."
	@stack path --local-install-root
	cp $(executable)/compressor-exe ./$(NAME)

clean:
	@echo "Cleaning..."
	@stack clean
	@echo "Cleaning done."

fclean:
	@echo "Cleaning..."
	@rm -f $(NAME)
	@rm -rf .stack-work
	@echo "Cleaning done."

re: fclean all
