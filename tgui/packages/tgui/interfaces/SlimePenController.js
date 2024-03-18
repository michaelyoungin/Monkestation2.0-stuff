import { useBackend, useLocalState } from '../backend';
import { Box, Table, Tabs, Collapsible, Stack, LabeledList, ProgressBar } from '../components';
import { Window } from '../layouts';
import { toFixed } from 'common/math';

export const SlimePenController = (_, context) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 1);

  return (
    <Window width={450} height={(tabIndex === 1 && 412) || 600}>
      <Window.Content>
        <Tabs style={{ 'border-radius': '5px' }}>
          <Tabs.Tab
            key={1}
            selected={tabIndex === 1}
            icon="flask"
            onClick={() => setTabIndex(1)}>
            Slime Data
          </Tabs.Tab>
        </Tabs>
        <Box>{tabIndex === 1 && <SlimeData />}</Box>
      </Window.Content>
    </Window>
  );
};

const SlimeData = (_, context) => {
  const { data } = useBackend(context);
  const { slimes } = data;

  return (
    <Table>
      {slimes.map((slime) => (
        <Collapsible key={slime.name} title={slime.name}>
          <Stack fill>
            <Stack.Item grow>
              <LabeledList>
                <LabeledList.Item label="Health">
                  <ProgressBar
                    ranges={{
                      bad: [0, 40],
                      average: [40, 70],
                      good: [70, 100],
                    }}
                    value={slime.health}
                    minValue={-100}
                    maxValue={100}>
                    {toFixed(slime.health, 0.1) + ' %'}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Hunger">
                  <ProgressBar
                    ranges={{
                      bad: [0, 40],
                      average: [40, 70],
                      good: [70, 100],
                    }}
                    value={slime.hunger_precent * 100}
                    minValue={-100}
                    maxValue={100}>
                    {toFixed(slime.hunger_precent * 100, 0.1) + ' %'}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Mutation Chance">
                  <ProgressBar
                    ranges={{
                      bad: [0, 40],
                      average: [40, 70],
                      good: [70, 100],
                    }}
                    value={slime.mutation_chance}
                    minValue={-100}
                    maxValue={100}>
                    {toFixed(slime.mutation_chance, 0.1) + ' %'}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Slime Color">
                  <Collapsible title={slime.slime_color}>
                    <LabeledList>
                      <LabeledList.Item label="Possible Mutations">
                        <Collapsible />
                      </LabeledList.Item>
                    </LabeledList>
                  </Collapsible>
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
          </Stack>
        </Collapsible>
      ))}
    </Table>
  );
};
