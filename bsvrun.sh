#!/bin/bash
# Copyright(c) 2023 https://github.com/gwbeip
#
# A script for running Bluespec SystemVerilog (BSV)

# simulation executable file suffix
bsim_file_suffix=".bsim" # for bluespec simulation

# parse options
# -tm   -->     top module
# -tf   -->     top file
# -cc   -->     simulation clock cycles, > 0
# -vcd  -->     dump *.vcd file in the simulation

. ./.bsvrun.profile

function parse {
    cnt=1
    for arg in "$@"
    do
        (( cnt=cnt+1 ))
        case $arg in 
            '-tm')
                top_module=$(eval echo -e \${$cnt})
                if [[ $top_module == "" || $top_module == -* ]]; then
                    echo -e $error_color"missing parameter for -tm option"$default_color
                fi
            ;;
            '-tf')
                top_file=$(eval echo -e \${$cnt})
                if [[ $top_file == "" || $top_file == -* ]]; then
                    echo -e $error_color"missing parameter for -tf option"$default_color
                fi
                # if [[ ! ( $top_file == ./$src* || $top_file == $src* ) ]]; then
                #     top_file=./$src/$top_file
                # fi
                if [[ ! $top_file == *bsv ]]; then # add .bsv suffix
                    top_file=$top_file.bsv
                fi
            ;;
            '-cc')
                cycle_count=$(eval echo -e \${$cnt})
                if [[ $cycle_count == "" || $cycle_count == -* ]]; then
                    echo -e $error_color"missing parameter for -cc option"$default_color
                fi
            ;;
            '-vcd')
                gen_vcd_file=1
            ;;
        esac
    done
}

# functions

function verilog {
    if [ ! -d $vdir ]; then
        mkdir $vdir
    fi
    if [ ! -d $bdir ]; then
        mkdir $bdir
    fi
    cd $src
	$compiler_name -verilog -vdir $vdir -bdir $bdir -g $top_module -u $top_file
    cd $current_dir
}

function bsim {
    if [ ! -d $bdir ]; then
        mkdir $bdir
    fi
    if [ ! -d $simdir ]; then
        mkdir $simdir
    fi
    cd $src
    bsc -bdir $bdir -sim -simdir $simdir -g $top_module -u $top_file
    bsc -bdir $bdir -sim -simdir $simdir -e $top_module -o $simdir/$top_module$bsim_file_suffix
    cd $current_dir
}

function rbsim {
    if [ ! -f $simdir/$top_module$bsim_file_suffix ]; then
        echo -e $error_color"simulation executable is inexistent, try to run 'bsim' before 'rbsim'"$default_color
    elif [ $simdir/$top_module$bsim_file_suffix -ot $src/$top_file ]; then
        echo -e $error_color"simulation executable is out-of-date, try to run 'bsim' before 'runsim'"$default_color
    else
        sim_options=""
        if [[ ! $cycle_count == 0 ]]; then
            sim_options="$sim_options -m $cycle_count"
        fi
        if [[ ! $gen_vcd_file == 0 ]]; then
            sim_options="$sim_options -V $simdir/$top_module.vcd"
        fi
        echo  running: $simdir/$top_module$bsim_file_suffix
        echo -en $runsim_color
        $simdir/$top_module$bsim_file_suffix $sim_options
        echo -en $default_color
    fi
}

function clean {
    if [ -d $bdir ]; then
        echo -e cleaning $bdir/
        rm -rf $bdir
    fi
    if [ -d $simdir ]; then
        echo -e cleaning $simdir/
        rm -rf $simdir
    fi
    if [ -d $vdir ]; then
        echo -e cleaning $vdir/
        rm -rf $vdir
    fi
}

# main
if [ $# -lt 1 ]; then
    echo -e $error_color"too few args, stop running"$default_color
fi

parse $@

for arg in "$@"
do
    if [[ ! $arg == -* ]]; then
        echo -e $note_color"@($(date))start: $arg"$default_color
        start_time=$(date +%s)
        case $arg in 
            'verilog')
                verilog
            ;;
            'clean')
                clean
            ;;
            'bsim')
                bsim
            ;;
            'rbsim')
                rbsim
            ;;
            *)
                echo -e $error_color"incorrect action name: $arg"$default_color
            ;;
        esac
        end_time=$(date +%s)
        run_time=$(($end_time - $start_time))
        if [[ $run_time == '0' || $run_time == '1' ]]; then
            run_time="($run_time second)"
        else
            run_time="($run_time seconds)"
        fi
        echo -e $note_color">($(date))end: $arg $run_time"$default_color
    else
        break
    fi
done
