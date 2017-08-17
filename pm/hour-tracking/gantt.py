import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import datetime
from matplotlib import dates
from matplotlib.dates import date2num, WEEKLY, MONTHLY, DateFormatter, rrulewrapper, RRuleLocator

# Display timetable
def parse_date(date):
    year, month, day = date.split('-')
    return date2num(datetime.datetime(int(year), int(month), int(day)))

def draw_gantt_project_plan(tasks, assignees):
    y = np.arange(len(tasks['description'])*4+0.5,0.5,-4)
    # Draw projected timeline
    bars = plt.barh(
        y + 0.7,
        np.subtract(list(map(parse_date, tasks['stop_planned'])),list(map(parse_date, tasks['start_planned']))),
        left=list(map(parse_date, tasks['start_planned'])),
        height=1,
        align='center',
        color='#cb4b16',
        alpha = 0.8,
    )
    
    stop_real_ts = list(map(parse_date, tasks['stop_real']))
    start_real_ts = list(map(parse_date, tasks['start_real']))
    today_ts = date2num(datetime.date.today())
    for i in range(0, len(stop_real_ts)):
        if stop_real_ts[i] >= today_ts and start_real_ts[i] <= today_ts:
            stop_real_ts[i] = today_ts
        elif stop_real_ts[i] >= today_ts and start_real_ts[i] >= today_ts:
            stop_real_ts[i] = start_real_ts[i]

    # Draw real projected timeline
    bars = plt.barh(
        y - 0.7,
        #%np.subtract(list(map(parse_date, tasks['stop_real'])),list(map(parse_date, tasks['start_real']))),
        np.subtract(stop_real_ts,start_real_ts),
        left=list(map(parse_date, tasks['start_real'])),
        height=1,
        align='center',
        color='#268bd2',
        alpha = 0.8
    )

    rule = rrulewrapper(WEEKLY, interval=1)
    loc = RRuleLocator(rule)
    plt.yticks(y, tasks['description'])
    formatter = DateFormatter("%d-%b")
    ax = plt.gca()
    ax.xaxis_date()
    ax.xaxis.set_major_formatter(formatter)
    ax.xaxis.set_major_locator(loc)
    ax.set_facecolor('#fdf6e3')
    ax.legend(['Planned','Effective'])
    labelsx = ax.get_xticklabels()
    plt.setp(labelsx, rotation=30, fontsize=10)
    plt.gcf().autofmt_xdate()
    plt.tight_layout()
    plt.savefig('timetable.pdf')


def draw_gantt_hour_tracking(tasks, assignees, hours):
    y = np.arange(len(tasks['description'])*4+0.5,0.5,-4)

    # Draw projected hours
    bars = plt.barh(
        y,
        tasks['projected_hours'],
        height=0.3,
        align='center',
        color='green',
        alpha = 0.8
    )
    
    a = []
    c = []
    for assignee in assignees.iterrows():
        a.append([])
        c.append(assignee[1]['color'])
        for task in tasks.iterrows():
            a[-1].append(hours.loc[(hours['assignee'] == assignee[0]) & (hours['task'] == task[0])]['amount'].sum())

    # Draw real hours
    last_a = [0 for task in tasks.iterrows()]
    for k, assignee in enumerate(a):
        bars = plt.barh(
            y - 0.3,
            assignee,
            left=last_a,
            height=0.1,
            align='center',
            color=c[k],
            alpha = 0.8
        )
        last_a = assignee

        plt.yticks(y, tasks['description'])
