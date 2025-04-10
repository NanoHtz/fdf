# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: fgalvez- <fgalvez-@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/08/08 14:04:17 by fgalvez-          #+#    #+#              #
#    Updated: 2025/04/03 11:33:04 by fgalvez-         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# ========================= VARIABLES GLOBALES =============================== #

NAME = fdf
CC = cc
CFLAGS = -Wall -Wextra -Werror
CFLAGSMINILIBX = -L minilibx-linux -lmlx -lXext -lX11 -lm
DEBUGGER = -g3
RM = rm -f
NORMINETTE = norminette

# ========================= DIRECTORIOS Y ARCHIVOS =========================== #

DIR_HEADERS = Inc/fdf Inc/libft Inc/get_next_line
DIR_FDF     = Inc/fdf
DIR_LIBFT   = Inc/libft
DIR_GNL     = Inc/get_next_line
HEADERS = $(wildcard $(DIR_FDF)/*.h) \
          $(wildcard $(DIR_LIBFT)/*.h) \
          $(wildcard $(DIR_GNL)/*.h)

DIRSOURCE   = src/
SOURCES.h = $(wildcard $(DIR_FDF)/*.c) \
           $(wildcard $(DIR_LIBFT)/*.c) \
           $(wildcard $(DIR_GNL)/*.c)

ifeq ($(BONUS),1)
	MLX = src/mlx_bonus.c src/bonus_utils.c src/controls_bonus.c src/bonus_utils_2.c
	SOURCES = $(filter-out src/mlx.c src/controls.c, $(wildcard $(DIRSOURCE)*.c)) $(MLX)
else
	MLX = src/mlx.c src/controls.c
	SOURCES = $(filter-out src/mlx_bonus.c src/bonus_utils.c src/controls_bonus.c src/bonus_utils_2.c, $(wildcard $(DIRSOURCE)*.c)) $(MLX)
endif


#SOURCES = $(filter-out src/mlx_bonus.c src/controls_bonus.c, $(wildcard $(DIRSOURCE)*.c)) $(MLX)
SRCS        = $(sort $(SOURCES) $(SOURCES.h))

OBJSDIR     = ./obj/
OBJS        = $(addprefix $(OBJSDIR), $(notdir $(SRCS:.c=.o)))

# ========================= COLORES PARA EL OUTPUT =========================== #

GREEN			= \033[0;32m
YELLOW			= \033[0;33m
CYAN			= \033[0;36m
MAGENTA			= \033[0;35m
RESET			= \033[0m

# ========================= REGLAS PRINCIPALES =============================== #
.PHONY: all clean fclean re n bonus

all: n $(NAME)

bonus:
	@$(MAKE) BONUS=1 all

$(NAME): $(OBJS)
	@echo "\n${MAGENTA}Compilando el ejecutable $(NAME)...${RESET}\n"
	$(CC) $(OBJS) $(CFLAGS) $(CFLAGSMINILIBX) $(DEBUGGER) -o $(NAME)
	@echo "${CYAN}=================================================================================================================${RESET}"
	@echo "${GREEN}                                       [✔] $(NAME) successfully compiled.${RESET}                               "
	@echo "${CYAN}=================================================================================================================${RESET}"
	@echo "${MAGENTA}You should use: valgrind --track-fds=yes ./$(NAME) maps/0.fdf${RESET}"
# ========================= REGLAS PARA LOS OBJETOS ========================== #
$(OBJSDIR)%.o: $(DIRSOURCE)%.c
	@mkdir -p $(dir $@)
	@echo "${CYAN}Compilando objeto: $<${RESET}"
	$(CC) $(CFLAGS) $(addprefix -I, $(DIR_HEADERS)) -c $< -o $@

$(OBJSDIR)%.o: $(DIR_FDF)/%.c
	@mkdir -p $(dir $@)
	@echo "${CYAN}Compilando objeto: $<${RESET}"
	$(CC) $(CFLAGS) $(addprefix -I, $(DIR_HEADERS)) -c $< -o $@

$(OBJSDIR)%.o: $(DIR_LIBFT)/%.c
	@mkdir -p $(dir $@)
	@echo "${CYAN}Compilando objeto: $<${RESET}"
	$(CC) $(CFLAGS) $(addprefix -I, $(DIR_HEADERS)) -c $< -o $@

$(OBJSDIR)%.o: $(DIR_GNL)/%.c
	@mkdir -p $(dir $@)
	@echo "${CYAN}Compilando objeto: $<${RESET}"
	$(CC) $(CFLAGS) $(addprefix -I, $(DIR_HEADERS)) -c $< -o $@

# ========================= LIMPIEZA DE ARCHIVOS ============================= #

clean:
	@echo "${YELLOW}Limpiando archivos objeto...${RESET}"
	 $(RM) -r $(OBJSDIR)

fclean: clean
	@echo "${YELLOW}Eliminando el ejecutable $(NAME)...${RESET}"
	$(RM)	$(NAME)

re: fclean all
# ========================= OTRAS REGLAS ===================================== #
n:
	@echo "${CYAN}=================================${RESET}"
	@echo "${GREEN}         Norminette.      ${RESET}"
	@echo "${CYAN}=================================${RESET}"
	@echo "\n"
	-$(NORMINETTE) $(HEADERS) $(SRCS) $(SOURCES2)
	@echo "\n"
	@echo "${GREEN}[✔] Norminette completa.${RESET}\n"

print-sources:
	@echo "Compilando con BONUS = $(BONUS)"
	@echo "SOURCES = $(SOURCES)"
