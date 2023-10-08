# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nsainton <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/05 10:02:14 by nsainton          #+#    #+#              #
#    Updated: 2023/10/08 09:59:55 by nsainto          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

SHELL=/usr/bin/bash

NAME=main.sh

SRCS_DIR=sources

SHELL_LINTER=shell_lint_check.mk

MAKEFLAGS=--no-print-directory

SCRIPT=$(SRCS_DIR)/$(NAME)

.SUFFIXES=
.SUFFIXES=.sh

all:	
	@cd $(SRCS_DIR) && ./$(NAME)

lint:
	@$(MAKE) -C $(SRCS_DIR) -f $(SHELL_LINTER)
