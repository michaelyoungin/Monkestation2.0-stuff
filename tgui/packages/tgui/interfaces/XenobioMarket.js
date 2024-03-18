import { useBackend, useLocalState } from '../backend';
import { Box, Section, Stack, Table, Tabs } from '../components';
import { Window } from '../layouts';
import { classes } from 'common/react';
import { toFixed } from 'common/math';

export const XenobioMarket = (_, context) => {
  const [tabIndex, setTabIndex] = useLocalState(context, 'tabIndex', 1);

  return (
    <Window width={900} height={(tabIndex === 1 && 412) || 600}>
      <Window.Content>
        <Tabs style={{ 'border-radius': '5px' }}>
          <Tabs.Tab
            key={1}
            selected={tabIndex === 1}
            icon="flask"
            onClick={() => setTabIndex(1)}>
            Slime Market
          </Tabs.Tab>
          <Tabs.Tab
            key={2}
            selected={tabIndex === 2}
            icon="flask"
            onClick={() => setTabIndex(2)}>
            Active Requests
          </Tabs.Tab>
        </Tabs>
        <Box>{tabIndex === 1 && <SlimeMarket />}</Box>
        <Box>{tabIndex === 2 && <RequestViewer />}</Box>
      </Window.Content>
    </Window>
  );
};

const SlimeMarket = (_, context) => {
  const { data } = useBackend(context);
  const { prices } = data;

  return (
    <Table>
      {prices.map((price_row) => (
        <Table.Row key={price_row.key}>
          {price_row.prices.map((slime_price) => (
            <Table.Cell width="25%" key={slime_price.key}>
              {!!slime_price.price && (
                <Section style={{ 'border-radius': '5px' }} mb="6px">
                  <Stack fill>
                    <Stack.Item>
                      <Box
                        className={classes([
                          'xenobio_market32x32',
                          slime_price.icon,
                        ])}
                      />
                    </Stack.Item>
                    <Stack.Item mt="10px">
                      Currect price: {toFixed(slime_price.price, 0)} points.
                    </Stack.Item>
                  </Stack>
                </Section>
              )}
            </Table.Cell>
          ))}
        </Table.Row>
      ))}
    </Table>
  );
};

const RequestViewer = (_, context) => {
  const { data } = useBackend(context);
  const { requests } = data;

  return (
    <Table>
      {requests.map((request) => (
        <Section style={{ 'border-radius': '5px' }} mb="6px" key={request.name}>
          <Stack fill>
            <Stack.Item>
              <Box
                style={{
                  'transform': 'scale(2)',
                }}
                className={classes(['xenobio_market32x32', request.icon])}
              />
            </Stack.Item>
            <Stack.Item mt="10px">{request.name}</Stack.Item>
            <Stack.Item mt="10px">
              | Payout: {toFixed(request.payout, 0)} credits. | Xenobiology
              Points: {toFixed(request.payout * 3, 0)}
            </Stack.Item>
            <Stack.Item mt="10px">
              | {toFixed(request.amount - request.amount_give, 0)} extracts
              left.
            </Stack.Item>
          </Stack>
        </Section>
      ))}
    </Table>
  );
};
