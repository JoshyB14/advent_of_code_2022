-- Day 1 

/* This list represents the Calories of the food carried by five Elves:

The first Elf is carrying food with 1000, 2000, and 3000 Calories, a total of 6000 Calories.
The second Elf is carrying one food item with 4000 Calories.
The third Elf is carrying food with 5000 and 6000 Calories, a total of 11000 Calories.
The fourth Elf is carrying food with 7000, 8000, and 9000 Calories, a total of 24000 Calories.
The fifth Elf is carrying one food item with 10000 Calories.
In case the Elves get hungry and need extra snacks, they need to know which Elf to ask: 
they'd like to know how many Calories are being carried by the Elf carrying the most Calories. 
In the example above, this is 24000 (carried by the fourth Elf).

Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

*/

-- import file + row number
with input as (
    select
        *,
        row_number() over() as row_number
    from read_csv('/Users/joshbryden/Desktop/github/advent_of_code_2022/input/day1.csv',
                            delim='False', 
                            columns={'calories': 'int'})
),

-- create flag for blank lines & partition over each elf's inventory
elves as (
    select
        *,
        case when calories is null then 1 end as blank_line_flag,
        row_number() over(partition by blank_line_flag order by row_number) as blank_line_row_number,
        row_number - blank_line_row_number as elf
    from input
),

-- find total calories for each elf
calories_by_elf as (
    select
        elf,
        sum(calories) as total_calories
    from elves
    where blank_line_flag is null -- filter out blank records. Cannot use <> 1
    group by elf
),

-- using cte above order elves and take top 1 for Day 1 part 1
top_elf_part1 as (
    select
        elf,
        total_calories
    from calories_by_elf
    order by total_calories desc
    limit 1
),

-- take top 3 elves for Day 1 part 2
top_3_elves as (
    select 
        elf,
        total_calories
    from calories_by_elf
    order by total_calories desc
    limit 3 
),

final as (
    select
        '1' as part_number,
        elf,
        total_calories as calories
    from top_elf_part1

    union all

    select
        '2' as part_number,
        'top 3 elves' as elf,
        sum(total_calories) as calories
    from top_3_elves
)

select * from final 


