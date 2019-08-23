##### Modules used #####

import pandas as pd

def unitroot_df_gen(data):
    
    age_groups = list(sorted(set(data['age_group'])))
    var_names = ['wealth', 'loans_per_person',
                'income_after', 'hs_grad', 'coll_grad', 'home_own']

    unitroot_test_df = pd.DataFrame()
    for var_name in var_names:
        # var_name = 'wealth'
        new_df = pd.DataFrame()
        for ind, age_group in enumerate(age_groups):
            # age_group = '21_30'
            if ind == 0:
                new_df = data.loc[data['age_group'] == age_group, ['dates', 'time', var_name]].rename(columns={var_name: age_group})
                new_df = new_df.set_index(pd.Series(
                    [var_name]*len(new_df))).reset_index().rename(columns={'index': 'var_of_int'}).reset_index(drop = True)
            else:
                new_df2 = data.loc[data['age_group'] == age_group, [var_name]].rename(
                    columns={var_name: age_group}).reset_index(drop=True)
                new_df = pd.concat([new_df, new_df2], axis = 1).reset_index(drop = True)
        unitroot_test_df = pd.concat(
            [unitroot_test_df, new_df], axis=0).reset_index(drop=True)
    
    return unitroot_test_df


def col_diffing(unitroot_test_df):

    # Probably an easier way of doing this
    cols_of_int = [0] + list(range(3, unitroot_test_df.shape[1]))

    time_comps = unitroot_test_df.loc[~(unitroot_test_df.var_of_int == 'hs_grad')].iloc[:, :3]
    diff_results = unitroot_test_df.loc[~(
        unitroot_test_df.var_of_int == 'hs_grad')].iloc[:, cols_of_int].groupby(['var_of_int']).diff()
    hs_grad_df = unitroot_test_df.loc[unitroot_test_df.var_of_int == 'hs_grad']

    unitroot_test_df = pd.concat([time_comps, diff_results], axis=1).dropna()
    unitroot_test_df = pd.concat(
        [unitroot_test_df, hs_grad_df], axis=0).reset_index().sort_values('index').rename(columns={'index': ''}).set_index('')


    unitroot_test_df['var_of_int'] = unitroot_test_df['var_of_int'].apply(
        lambda x: 'd_' + x if x != 'hs_grad' else x)

    return unitroot_test_df


def panel_df_gen(unitroot_test_df):

    # Again, probably an easier way of doing this

    age_groups = list(unitroot_test_df.columns)[3:]
    features = sorted(set(unitroot_test_df['var_of_int']), reverse = True)

    panel_data = pd.DataFrame()
    for feat in features:
        feat_data = pd.DataFrame()
        for age_group in age_groups:
            # age_group = '21_30'; feat = 'd_wealth'
            age_data = unitroot_test_df.loc[unitroot_test_df['var_of_int'] == feat, ['dates', 'time',
                age_group]].rename(columns={age_group: feat})
            age_data = age_data.set_index(pd.Series([age_group]*len(age_data))).reset_index().rename(columns = {'index':'age_group'})
            feat_data = pd.concat([feat_data, age_data], axis = 0)
        if feat == 'hs_grad':
            panel_data = pd.concat([panel_data, feat_data], axis=1)
        else:
            panel_data = pd.merge(panel_data, feat_data[['age_group', 'dates', feat]], left_on=[
                    'age_group', 'dates'], right_on=['age_group', 'dates'], how='left')

    return panel_data
