#include <cstdio>
#include <vector>
#include <queue>
#include <deque>
#include <utility>


class Solution {
private:
    using Station = std::pair<int, int>;
    int stations_count, total_distance, fuel_tank_capacity;
    std::vector<Station> ranges;

public:
    Solution(int stations_count, int total_distance, int fuel_tank_capacity) {
        this->stations_count = stations_count;
        this->total_distance = total_distance;
        this->fuel_tank_capacity = fuel_tank_capacity;
        ranges.resize(stations_count + 2);
    }

    void loadStations() {
        int distance, cost;
        std::queue<Station> ranges_queue;
        ranges[0] = Station(0, 0);
        ranges_queue.emplace(0, fuel_tank_capacity);
        for (int i = 1; i <= stations_count; i++) {
            scanf("%d %d", &distance, &cost);
            while (ranges_queue.front().second < distance) {
                ranges_queue.pop();
                if (ranges_queue.empty()) throw -1;
            }
            ranges[i] = Station(
                cost, ranges_queue.front().first);
            ranges_queue.emplace(i, fuel_tank_capacity + distance);
        }
        while (ranges_queue.front().second < total_distance) {
            ranges_queue.pop();
            if (ranges_queue.empty()) throw -1;
        }
        ranges[stations_count + 1] = Station(
            0, ranges_queue.front().first);
    }

    int getCost() {
        int difference, new_cost, new_range;
        std::deque<Station> window;
        window.emplace_front(0, 1);
        
        for (int i = 1; i <= stations_count + 1; i++) {
            difference = ranges[i].second - ranges[i - 1].second;

           while (difference > 0) {
               if (window.back().second > difference) {
                   window.back().second -= difference;
                   difference = 0;
               } else {
                   difference -= window.back().second;
                   window.pop_back();
               }
           }

            new_cost = window.back().first + ranges[i].first;
            new_range = 1;
            while (!window.empty() && window.front().first >= new_cost) {
                new_range += window.front().second;
                window.pop_front();
            }
            window.emplace_front(new_cost, new_range);
        }
        return window.back().first;
    }
};


int main() {
    int stations_count, total_distance, fuel_tank_capacity;
    scanf("%d %d %d", &stations_count, &total_distance, &fuel_tank_capacity);

    Solution solution = Solution(stations_count, total_distance, fuel_tank_capacity);
    try {
        solution.loadStations();
    } catch(int) {
        printf("NIE\n");
        return 0;
    }
    printf("%d\n", solution.getCost());

    return 0;
}
