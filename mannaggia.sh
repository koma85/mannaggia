#!/bin/sh
# Needs coreutils (brew install voreutils)
############################################################
# Mannaggiatore automatico per VUA depressi
# idea originale by Alexiobash dallo script incazzatore.sh
# ampliata, riscritta e mantenuta da Pietro "Legolas" Suffritti
# convertita in mannaggia.sh rel 0.2
# patcher e contributors:
# Marco Placidi, Maurizio "Tannoiser" Lemmo, Matteo Panella
# Mattia Munari
# thanks to : Veteran Unix Admins group on Facebook
# released under GNU-GPLv3
############################################################
# parametri da command line:
# --audio : attiva mplayer per fargli pronunciare i santi
# --spm <n> : numero di santi per minuto
# --wall : invia l'output a tutte le console : attenzione , se non siete root o sudoers disattivare il flag -n
# --nds <n> : numero di santi da invocare (di default continua all'infinito)

audioflag=false
spm=1
spmflag=false
nds=-1
pot=-1
ndsflag=false
wallflag=false
DELSTRING1="</FONT>"
DELSTRING1="</FONT"
DELSTRING2="</b>"
DELSTRING2="</b"
PLAYER="mplayer -really-quiet -ao alsa"
PLAYER="say"
VOICE="Alice"
RANDOMCHAR="$(base64 /dev/urandom | tr -d '/+'|tr -dc 'A-Z' | fold -w 1 | head -n 1)"
# lettura parametri da riga comando
for parm in "$@"
	do
	# leggi dai parametri se c'e' l'audio
	if [ "$parm" = "--audio" ]
		then
		audioflag=true
	fi

	# leggi dai parametri se c'e' da mandare i commenti su wall
	if [ "$parm" = "--wall" ]
		then
		wallflag=true
	fi

	# se spmflag
	# imposta i santi per minuto e resetta il flag
	if [ "$spmflag" = true ]
		then
		if [ $parm -lt 1 ]
			then
			spm=1
			spmflag=false
			else
			spm=$((60 / parm))
			spmflag=false
		fi
	fi

	# se parm = --spm
	# setta il flag spmflag
	if [ "$parm" = "--spm" ]
		then
		spmflag=true
	fi

	# se ndsflag
	# imposta il numero di santi da ciclare
	if [ "$ndsflag" = true ]
		then
		nds="$parm"
		ndsflag=false
	fi

	# se parm = --nds
	# setta il flag ndsflag
	if [ "$parm" = "--nds" ]
		then
		ndsflag=true
	fi
done

while [ "$nds" != 0 ]
	do
	# shellcheck disable=SC2019
#	MANNAGGIA="Mannaggia $(curl -s "www.santiebeati.it/$(</dev/urandom tr -dc A-Z|head -c1)/"|grep tit|cut -d'>' -f 4-9|shuf -n1 |awk -F "$DELSTRING1" '{print$1$2}'|awk -F "$DELSTRING2" '{print$1}')"
	#MANNAGGIA="Mannaggia $(curl -s "www.santiebeati.it/${RANDOMCHAR}/"|grep tit|cut -d'>' -f 4-9|gshuf -n1 |awk -F "$DELSTRING1" '{print$1$2}'|awk -F "$DELSTRING2" '{print$1}')"
	MANNAGGIA="Mannaggia $(curl -s "www.santiebeati.it/${RANDOMCHAR}/"|grep tit|awk -F'>' '{print $4" "$5" "$6" "$7" "$8" "$8}'|gshuf -n1 |awk -F "$DELSTRING1" '{print$1$2}'|awk -F "$DELSTRING2" '{print$1}')"
	#MANNAGGIA2="Mannaggia $(curl -s "www.santiebeati.it/${RANDOMCHAR}/"|grep tit)"
	#echo $MANNAGGIA2
	MANNAGGIAURL="http://translate.google.com/translate_tts?tl=it&q=$MANNAGGIA"

	if [ "$wallflag" = true ]
		then
		pot=$(( nds % 50 ))
		if [ "$pot" = 0 ]
			then
			echo "systemd merda, poettering vanaglorioso fonte di danni, ti strafulmini santa cunegonda bipalluta protrettice dei VUA"
			else
			# attenzione: se non siete root o sudoers dovete togliere dalla riga successiva "sudo" e "-n"
			echo "$MANNAGGIA" | sudo wall -n
		fi
		else
		echo "$MANNAGGIA" > /dev/stdout
	fi

	if [ "$audioflag" = true ]
		then
		if [ "$PLAYER" == "say" ]; then
			say -v "$VOICE" $MANNAGGIA
		else
			$PLAYER "$MANNAGGIAURL" 2>/dev/null
		fi
	fi

	sleep "$spm"
	nds=$((nds - 1))
done
