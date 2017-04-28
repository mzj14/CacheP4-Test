if __name__ == '__main__':
    with open('latency.txt', 'r') as f:
        lines = f.readlines()
    times = [ float(line.split()[-2]) for line in lines ]
    # print(lines)
    # print(times)
    print('max', max(times))
    print('min', min(times))
    print('avg', sum(times)/len(times))
