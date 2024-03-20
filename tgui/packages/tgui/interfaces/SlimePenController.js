import { useBackend, useLocalState } from '../backend';
import { Box, Table, Tabs, Collapsible, Stack, LabeledList, ProgressBar, Section, Button } from '../components';
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
                    minValue={0}
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
                    minValue={0}
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
                    minValue={0}
                    maxValue={100}>
                    {toFixed(slime.mutation_chance, 0.1) + ' %'}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Possible Mutations">
                  <Collapsible title={slime.slime_color + ' Mutations'}>
                    {slime.possible_mutations.map((mutation) => (
                      <Section
                        key={mutation.color}
                        backgroundColor={
                          !mutation.mobs_needed & !mutation.items_needed
                            ? 'green'
                            : ''
                        }>
                        <Stack>
                          <Box>{mutation.color + ' Slime'}</Box>
                          <Button
                            ml="10px"
                            icon={'spider'}
                            disabled={!mutation.mobs_needed}
                            tooltip={mutation.mobs_needed}
                          />
                          <Button
                            ml="10px"
                            icon={'drumstick-bite'}
                            disabled={!mutation.items_needed}
                            tooltip={mutation.items_needed}
                          />
                        </Stack>
                      </Section>
                    ))}
                  </Collapsible>
                </LabeledList.Item>
                <LabeledList.Item label="Slime Traits">
                  <Collapsible title="Current Traits">
                    {slime.traits.map((trait) => (
                      <Section key={trait.name}>
                        <Stack>
                          <Box>{trait.name + ' Slime'}</Box>
                          <Button
                            ml="10px"
                            icon={'drumstick-bite'}
                            disabled={!trait.food}
                            tooltip="Changes the Slimes feeding habits."
                          />
                          {!!trait.behaviour && (
                            <Button
                              ml="5px"
                              icon={'dice-d6'}
                              disabled={!trait.behaviour}
                              tooltip="Changes or Adds new behaviours to the slime."
                            />
                          )}
                          {!!trait.environment && (
                            <Button
                              ml="5px"
                              icon={'igloo'}
                              disabled={!trait.environment}
                              tooltip="Requires the Slime's pen be changed to facilitate this trait."
                            />
                          )}
                          {!!trait.danger && (
                            <Button
                              ml="5px"
                              icon={'skull'}
                              disabled={!trait.danger}
                              tooltip="This trait makes the slime more dangerous."
                            />
                          )}
                          {!!trait.docile && (
                            <Button
                              ml="5px"
                              icon={'shield-cat'}
                              disabled={!trait.docile}
                              tooltip="This makes the slime generally harmless to normal humans."
                            />
                          )}
                          <Button
                            ml="5px"
                            icon={'question'}
                            disabled={!trait.desc}
                            tooltip={trait.desc}
                          />
                        </Stack>
                      </Section>
                    ))}
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
