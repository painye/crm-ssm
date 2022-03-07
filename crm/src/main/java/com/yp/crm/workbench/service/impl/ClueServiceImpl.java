package com.yp.crm.workbench.service.impl;
/**
 * @author pan
 * @date 2022/3/6 11:05
 */

import com.yp.crm.workbench.domain.Clue;
import com.yp.crm.workbench.mapper.ClueMapper;
import com.yp.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @ClassName : com.yp.crm.workbench.service.impl.ClueServiceImpl
 * @Description : 类描述
 * @author pan
 * @date 2022/3/6 11:05
 */

@Service("clueServiceImpl")
public class ClueServiceImpl implements ClueService {
    @Autowired
    private ClueMapper clueMapper;

    @Override
    public int addClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        List<Clue> clueList = clueMapper.queryClueByConditionForPage(map);
        System.out.println(clueList);
        return  clueList;
    }

    @Override
    public int queryClueCountByCondition(Map<String, Object> map) {
        return clueMapper.queryClueCountsByCondition(map);
    }

    @Override
    public int deleteClueById(String id) {
        return clueMapper.deleteClueById(id);
    }

    @Override
    public int editClue(Clue clue) {
        return clueMapper.updateClue(clue);
    }

    @Override
    public Clue queryClue(String id) {
        Clue clue =clueMapper.selectClueById(id);
        System.out.println(clue.getCreateBy()+"------"+clue.getEditBy());
        return clue;
    }

    @Override
    public Clue queryClueByIdForTail(String id) {
        Clue clue= clueMapper.selectClueByIdForTail(id);
        System.out.println(clue);
        return clue;
    }
}
